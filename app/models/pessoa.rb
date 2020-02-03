class Pessoa < ApplicationRecord
  belongs_to :logradouro
  has_many :conexoes
  has_many :contratos
  has_one_attached :rg_imagem

  delegate :endereco, to: :logradouro, prefix: :logradouro

  enum tipo: {"Pessoa Física" => 1, "Pessoa Jurídica" => 2}

  def endereco
    self.logradouro.nome + ', ' + self.numero + ' ' + self.complemento
  end

  def idade
    ((Time.zone.now - nascimento.to_time) / 1.year.seconds).floor
  end

  def cpf_cnpj
    self.cpf.present? ? self.cpf : self.cpf
  end

  def rg_ie
    self.rg.present? ? self.rg : self.ie
  end

  def assinante?
    conexoes.count > 0
  end

end
