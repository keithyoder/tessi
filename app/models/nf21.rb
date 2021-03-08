class Nf21 < ApplicationRecord
  has_many :nf21_itens
  belongs_to :fatura

  after_create :gerar_registros

  def gerar_registros
    update!(
      cadastro: Nf21Cadastro.new(self).generate,
      mestre: Nf21Mestre.new(self).generate
    )
    nf21_itens.create(item: Nf21ItemRecord.new(self).generate)
  end
end
