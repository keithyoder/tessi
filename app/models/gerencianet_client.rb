class GerencianetClient
  require 'gerencianet'

  def self.criar_boleto(fatura)
    cliente = Gerencianet.new(
      {
        client_id: fatura.pagamento_perfil.client_id,
        client_secret: fatura.pagamento_perfil.client_secret,
        sandbox: true
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
        notification_url: 'https://erp.tessi.com.br/webhooks/'+Webhook.find_by(tipo: :gerencianet).token
      },
      payment: {
        banking_billet: {
          expire_at: fatura.vencimento.strftime,
          customer: {
            name: fatura.pessoa.nome.strip,
            #email: fatura.pessoa.email,
            cpf: CPF.new(fatura.pessoa.cpf).stripped.to_s,
            birth: fatura.pessoa.nascimento.strftime,
            phone_number: fatura.pessoa.telefone1.gsub(/\s+/, ""),
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
          conditional_discount: {
            type: "currency",
            value: (fatura.plano.desconto * 100).to_i,
            until_date: fatura.vencimento,
          },
          configurations: {
            fine: 200,
            interest: 33
          },
        }
      }
    }

    response = cliente.create_charge_onestep(body: body)
    return unless response['code'] == 200
    data = response['data']
    fatura.update(
      pix: data['pix']['qrcode'],
      id_externo: data['charge_id'],
      link: data['link'],
      codigo_de_barras: data['barcode']
    )
  end

  def self.receber_notificacao(notificacao)
    perfil = PagamentoPerfil.find_by(banco: 364)
    cliente = Gerencianet.new(
      {
        client_id: perfil.client_id,
        client_secret: perfil.client_secret,
        sandbox: true
      }
    )
    params = {
      token: notificacao
    }
     
    cliente.get_notification(params: params)
  end

  def self.processar_webhook(notificacao)
    payload = self.receber_notificacao(notificacao)
    return unless payload['code'] == 200

    pago = payload['data'].find { |evento| evento['type'] == 'charge' && evento['status']['current'] == 'paid' }
    return unless pago

    fatura = Fatura.find(pago['custom_id'].to_i)
    valor_pago = pago['value']
    desconto = (fatura.valor - valor_pago if valor_pago < fatura.valor)
    juros = (fatura.valor - valor_pago if valor_pago > fatura.valor)

    
    fatura.update(
      liquidacao: pago['received_by_bank_at'],
      valor_liquidacao: valor_pago,
      desconto_concedido: desconto,
      juros_recebidos: juros,
      meio_liquidacao: :RetornoBancario
    )
  end
end
