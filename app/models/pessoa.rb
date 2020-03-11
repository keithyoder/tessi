class Pessoa < ApplicationRecord
  belongs_to :logradouro
  has_one :bairro, through: :logradouro
  has_one :cidade, through: :logradouro
  has_many :conexoes
  has_many :contratos
  has_one_attached :rg_imagem

  delegate :endereco, to: :logradouro, prefix: :logradouro

  enum tipo: {"Pessoa Física" => 1, "Pessoa Jurídica" => 2}

  def endereco
    logradouro.nome + ', ' + numero + ' ' + complemento
  end

  def idade
    ((Time.zone.now - nascimento.to_time) / 1.year.seconds).floor
  end

  def cpf_cnpj
    if self.cpf.present?
      pessoa.cpf.gsub(/[^0-9 ]/, '')
    else
      pessoa.cnpj.gsub(/[^0-9 ]/, '')
    end
  end

  def rg_ie
    self.rg.present? ? self.rg : self.ie
  end

  def assinante?
    conexoes.count > 0
  end

end
