class PagamentoPerfil < ApplicationRecord
  has_many :faturas
  enum tipo: { "Boleto" => 3, "Débito Automático" => 2 }

  def remessa(pagamentos)
    info = {
      carteira: carteira.to_s,
      agencia: agencia.to_s,
      conta_corrente: conta.to_s,
      digito_conta: '1',
      empresa_mae: 'asd',
      sequencial_remessa: '1',
      documento_cedente: Settings.cnpj,
      pagamentos: pagamentos,
      codigo_transmissao: '123456'
    }
    case banco
    when 33
      Brcobranca::Remessa::Cnab400::Santander.new(info)
    when 1
      Brcobranca::Remessa::Cnab400::BancoBrasil.new(info)
    end
  end
end
