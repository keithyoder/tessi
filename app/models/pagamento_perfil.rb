class PagamentoPerfil < ApplicationRecord
  has_many :faturas
  has_many :retornos
  enum tipo: { 'Boleto' => 3, 'Débito Automático' => 2 }

  def remessa(sequencia = 1)
    pagamentos = faturas_para_registrar + faturas_para_baixar + faturas_canceladas
    case banco
    when 33
      remessa_santander(pagamentos)
    when 1
      remessa_banco_brasil(pagamentos, sequencia)
    end
  end

  def proximo_nosso_numero
    faturas.select('MAX(nossonumero::bigint) as nossonumero')
           .where("nossonumero ~ E'^\\\\d+$'")
           .to_a[0][:nossonumero]
           .to_i
  end

  private

  def remessa_banco_brasil(pagamentos, sequencia)
    Brcobranca::Remessa::Cnab400::BancoBrasil.new(
      remessa_attr(pagamentos).merge(
        sequencial_remessa: sequencia,
        variacao_carteira: variacao.to_s,
        convenio: cedente.to_s,
        convenio_lider: cedente.to_s
      )
    )
  end

  def remessa_santander(pagamentos)
    Brcobranca::Remessa::Cnab400::Santander.new(
      remessa_attr(pagamentos).merge(
        codigo_transmissao: santander_codigo_transmissao,
        codigo_carteira: variacao.to_s,
      )
    )
  end

  def remessa_attr(pagamentos)
    {
      carteira: carteira.to_s,
      agencia: agencia.to_s,
      conta_corrente: conta.to_s,
      digito_conta: '1',
      empresa_mae: 'TESSI Tec. em Seg. e Sistemas',
      documento_cedente: Setting.cnpj,
      pagamentos: pagamentos,
    }
  end

  def santander_codigo_transmissao
    (agencia.to_s + '0' + cedente.to_s + conta.to_s.rjust(10, '0'))[0...20]
  end

  def faturas_com_numero
    faturas.eager_load(%i[pessoa logradouro bairro cidade estado plano])
           .where.not(nossonumero: '')
  end

  def faturas_para_registrar
    # registrar todos os boletos com vencimento nos proximos 30 dias
    # e que nao foram liquidados ainda e nao foram registrados anteriormente.
    faturas_com_numero.where(
      vencimento: Date.today..30.days.from_now,
      cancelamento: nil,
      liquidacao: nil,
      registro_id: nil
    ).map(&:remessa)
  end

  def faturas_para_baixar
    # baixar todos os boletos que foram liquidados nos ultimos 30 dias
    # nao por meio bancario ainda e nao foram baixados anteriormente.
    faturas_com_numero.where(
      retorno_id: nil,
      baixa_id: nil,
      liquidacao: 1.month.ago..Date.today
    ).where.not(liquidacao: nil, registro_id: nil).map(&:remessa)
  end

  def faturas_canceladas
    # baixar todos os boletos que foram canceladas e nao foram baixados anteriormente.
    faturas_com_numero.where(
      retorno_id: nil,
      baixa_id: nil,
    ).where.not(cancelamento: nil, registro_id: nil).map(&:remessa)
  end
end
