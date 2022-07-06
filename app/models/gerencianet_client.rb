# frozen_string_literal: true

class GerencianetClient
  require 'gerencianet'

  def self.criar_boleto(fatura)
    # não criar um novo boleto se já foi criado anteriormente.
    return unless fatura.pagamento_perfil.banco == 364 && fatura.pix.blank?

    cliente = Gerencianet.new(
      {
        client_id: fatura.pagamento_perfil.client_id,
        client_secret: fatura.pagamento_perfil.client_secret,
        sandbox: ENV['RAILS_ENV'] != 'production'
      }
    )

    body = {
      items: [
        {
          name: fatura.plano.nome,
          value: (fatura.valor * 100).to_i,
          amount: 1
        }
      ],
      metadata: {
        custom_id: fatura.id.to_s,
        notification_url: "https://erp.tessi.com.br/webhooks/#{Webhook.find_by(tipo: :gerencianet).token}"
      },
      payment: {
        banking_billet: {
          expire_at: fatura.vencimento.strftime,
          customer: {
            # email: fatura.pessoa.email,
            phone_number: fatura.pessoa.telefone1.gsub(/\s+/, ''),
            address: {
              street: fatura.pessoa.logradouro.nome,
              number: fatura.pessoa.numero,
              neighborhood: fatura.pessoa.bairro.nome,
              zipcode: fatura.pessoa.logradouro.cep.to_s,
              city: fatura.pessoa.cidade.nome,
              complement: fatura.pessoa.complemento,
              state: fatura.pessoa.estado.sigla
            }
          },
          configurations: {
            fine: 200,
            interest: 33
          }
        }
      }
    }

    if fatura.desconto.positive?
      body.deep_merge!(
        conditional_discount: {
          type: 'currency',
          value: (fatura.desconto * 100).to_i,
          until_date: fatura.vencimento
        }
      )
    end

    body.deep_merge!(
      if fatura.pessoa.pessoa_fisica?
        {
          payment: {
            banking_billet: {
              customer: {
                name: fatura.pessoa.nome.strip,
                cpf: CPF.new(fatura.pessoa.cpf).stripped.to_s,
                birth: fatura.pessoa.nascimento&.strftime
              }
            }
          }
        }
      else
        {
          payment: {
            banking_billet: {
              customer: {
                juridical_person: {
                  corporate_name: fatura.pessoa.nome.strip,
                  cnpj: CNPJ.new(fatura.pessoa.cnpj).stripped.to_s
                }
              }
            }
          }
        }
      end
    )

    response = cliente.create_charge_onestep(body: body)
    return unless response['code'] == 200

    data = response['data']
    nossonumero = data['barcode'][25, 11].gsub(/\D/, '')
    fatura.update(
      pix: data['pix']['qrcode'],
      id_externo: data['charge_id'],
      link: data['link'],
      codigo_de_barras: data['barcode'],
      nossonumero: nossonumero
    )
  end

  def self.cliente
    perfil = PagamentoPerfil.find_by(banco: 364)
    cliente = Gerencianet.new(
      {
        client_id: perfil.client_id,
        client_secret: perfil.client_secret,
        sandbox: ENV['RAILS_ENV'] != 'production'
      }
    )
  end

  def self.receber_notificacao(notificacao)
    params = {
      token: notificacao
    }

    cliente.get_notification(params: params)
  end

  def self.processar_webhook(evento)
    Rails.logger.info 'Inciando processamento'
    return if evento.processed_at.present?

    payload = receber_notificacao(evento.notificacao)
    Rails.logger.info 'Notificacao recebida'
    return unless payload['code'] == 200

    Rails.logger.debug payload
    pago = payload['data'].find { |evento| evento['type'] == 'charge' && evento['status']['current'] == 'paid' }
    registro = payload['data'].find { |evento| evento['type'] == 'charge' && evento['status']['current'] == 'waiting' }
    cancelado = payload['data'].find do |evento|
      evento['type'] == 'charge' && evento['status']['current'] == 'canceled'
    end
    Rails.logger.info 'Processando pagamento' if pago 
    Rails.logger.info 'Processando registro' if registro
    Rails.logger.info 'Processando cancelamento' if cancelado

    return unless pago || registro || cancelado

    if pago
      fatura = Fatura.find(pago['custom_id'].to_i)
      valor_pago = pago['value']
      desconto = (fatura.valor - valor_pago if valor_pago < fatura.valor)
      juros = (fatura.valor - valor_pago if valor_pago > fatura.valor)

      fatura.update(
        liquidacao: pago['received_by_bank_at'],
        valor_liquidacao: valor_pago / 100,
        desconto_concedido: desconto / 100,
        juros_recebidos: juros / 100,
        meio_liquidacao: :RetornoBancario
      )
    elsif cancelado
      fatura = Fatura.find_by(id: cancelado['custom_id'].to_i)

      if fatura.present?
        if fatura.cancelamento.blank?
          fatura.update(data_cancelamento: evento.created_at.to_date)
        else
          fatura.destroy
        end
      end
    elsif registro
      fatura = Fatura.find(registro['custom_id'].to_i)
      return if fatura.registro.present?

      perfil = PagamentoPerfil.find_by(banco: 364)
      retorno = Retorno.create(
        pagamento_perfil: perfil,
        data: evento.created_at.to_date,
        sequencia: evento.id
      )
      fatura.update(registro_id: retorno.id) if fatura.registro_id.blank?
    end
    evento.update(processed_at: DateTime.now)
  end

  def self.alterar_vencimento(fatura)
    return unless fatura.pagamento_perfil.banco == 364 && fatura.pix.blank?

    cliente = Gerencianet.new(
      {
        client_id: fatura.pagamento_perfil.client_id,
        client_secret: fatura.pagamento_perfil.client_secret,
        sandbox: ENV['RAILS_ENV'] != 'production'
      }
    )

    params = {
      id: fatura.id_externo
    }

    body = {
      expire_at: fatura.vencimento.to_s
    }
    cliente.update_billet(params: params, body: body)
  end

  def pessoa_fisica_attributes
    {
      payment: {
        banking_billet: {
          customer: {
            name: @fatura.pessoa.nome.strip,
            cpf: CPF.new(@fatura.pessoa.cpf).stripped.to_s,
            birth: @fatura.pessoa.nascimento&.strftime
          }
        }
      }
    }
  end

  def pessoa_juridica_attributes
    {
      payment: {
        banking_billet: {
          customer: {
            juridical_person: {
              corporate_name: @fatura.pessoa.nome.strip,
              cnpj: CNPJ.new(@fatura.pessoa.cpf).stripped.to_s
            }
          }
        }
      }
    }
  end
end
