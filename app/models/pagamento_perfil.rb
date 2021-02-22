class PagamentoPerfil < ApplicationRecord
  has_many :faturas
  has_many :retornos
  enum tipo: { "Boleto" => 3, "Débito Automático" => 2 }

  def remessa(pagamentos)
    info = {
      carteira: carteira.to_s,
      agencia: agencia.to_s,
      conta_corrente: conta.to_s,
      digito_conta: '1',
      empresa_mae: 'TESSI Tec. em Seg. e Sistemas',
      sequencial_remessa: '1',
      documento_cedente: Setting.cnpj,
      pagamentos: pagamentos,
    }
    case banco
    when 33
      Brcobranca::Remessa::Cnab400::Santander.new(
        info.merge(
          {
            codigo_transmissao: agencia.to_s + cedente.to_s,
            codigo_carteira: '5',
          }
        )
      )
    when 1
      Brcobranca::Remessa::Cnab400::BancoBrasil.new(
        info.merge(
          {
            variacao_carteira: '019',
            convenio: cedente.to_s,
            convenio_lider: cedente.to_s
          }
        )
      )
    end
  end
end
