class Nf21 < ApplicationRecord
  has_many :nf21_itens
  belongs_to :fatura
  scope :competencia, ->(mes) { where("date_trunc('month', emissao) = ?", DateTime.parse(mes + '-01'))}

  after_create :gerar_registros

  def gerar_registros
    update!(
      cadastro: Nf21Cadastro.new(self).generate,
      mestre: Nf21Mestre.new(self).generate
    )
    nf21_itens.first_or_initialize.tap do |item|
      item.item = Nf21ItemRecord.new(self).generate
      item.save
    end
  end

  def referencia_item
    Nf21Item.competencia(mes)
            .select('count(*) as itens')
            .joins(:nf21)
            .where('nf21s.numero < ?', numero)[0].itens + 1
  end

  def mes
    emissao.strftime('%Y-%m')
  end

  def terminal
    '87' + fatura.contrato.id.to_s.rjust(9, '9')
  end

  def serie
    'U'
  end

  def modelo
    21
  end

  def tipo_utilizacao
    2
  end
end
