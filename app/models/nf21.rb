class Nf21 < ApplicationRecord
  has_many :nf21_itens
  belongs_to :fatura

  def gerar_registros
    cadastro = Nf21Cadastro.new(self).generate
    mestre = Nf21Mestre.new(self).generate
    save!
    nf21_itens.create(item: Nf21ItemRecord.new(self).generate)
  end

end
