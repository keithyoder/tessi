class PagamentoPerfil < ApplicationRecord
  has_many :faturas
  enum tipo: { "Boleto" => 3, "Débito Automático" => 2 }

  def remessa(pagamentos)
    case banco
    when 33
      Brcobranca::Remessa::Cnab400::Santander.new(carteira: carteira.to_s,
        agencia: agencia.to_s,
        conta_corrente: conta.to_s,
        digito_conta: '1',
        empresa_mae: 'asd',
        sequencial_remessa: '1',
        documento_cedente: '07159053000107',
        pagamentos: pagamentos,
        codigo_transmissao: '123456')
    when 1
      Brcobranca::Remessa::Cnab400::BancoBrasil.new(carteira: '01',
        agencia: '12345',
        conta_corrente: '1234567',
        digito_conta: '1',
        empresa_mae: 'asd',
        sequencial_remessa: '1',
        codigo_empresa: '123',
        pagamentos: pagamentos)
    end
  end
end
