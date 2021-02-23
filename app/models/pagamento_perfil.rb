class PagamentoPerfil < ApplicationRecord
  has_many :faturas
  has_many :retornos
  enum tipo: { 'Boleto' => 3, 'Débito Automático' => 2 }

  def remessa(pagamentos)
    case banco
    when 33
      remessa_santander(pagamentos)
    when 1
      remessa_banco_brasil(pagamentos)
    end
  end

  private

  def remessa_banco_brasil(pagamentos)
    Brcobranca::Remessa::Cnab400::BancoBrasil.new(
      remessa_attr(pagamentos).merge(
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
      sequencial_remessa: '1',
      documento_cedente: Setting.cnpj,
      pagamentos: pagamentos,
    }
  end

  def santander_codigo_transmissao
    (agencia.to_s + '0' + cedente.to_s + conta.to_s.rjust(10, '0'))[0...20]
  end
end
