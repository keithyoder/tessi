class Pessoa < ApplicationRecord
  belongs_to :logradouro
  has_one :bairro, through: :logradouro
  has_one :cidade, through: :logradouro
  has_one :estado, through: :logradouro
  has_many :conexoes
  has_many :contratos
  has_many :os
  has_one_attached :rg_imagem
  usar_como_cnpj :cnpj
  usar_como_cpf :cpf
  scope :assinantes, -> { select('pessoas.id').joins(:conexoes).group("pessoas.id").having("count(*) > 0") }

  delegate :endereco, to: :logradouro, prefix: :logradouro

  enum tipo: { 'Pessoa Física' => 1, 'Pessoa Jurídica' => 2 }

  validates :tipo, presence: true
  validates :telefone1, presence: true
  #validates :cpf, uniqueness: true, allow_blank: true
  #validates :cnpj, uniqueness: true, allow_blank: true

  def endereco
    logradouro.nome + ', ' + numero + ' ' + complemento
  end

  def idade
    ((Time.zone.now - nascimento.to_time) / 1.year.seconds).floor
  end

  def cpf_cnpj
    (cpf.present? ? cpf : cnpj).gsub(/[^0-9 ]/, '')
  end

  def cpf_cnpj_formatado
    cpf.present? ? cpf.to_s : cnpj.to_s
  end

  def tipo_documento
    tipo == 'Pessoa Física' ? 'CPF' : 'CNPJ'
  end

  def rg_ie
    rg.present? ? rg : ie
  end

  def assinante?
    conexoes.count.positive?
  end
end
