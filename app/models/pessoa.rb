class Pessoa < ApplicationRecord
  belongs_to :logradouro
  has_one :bairro, through: :logradouro
  has_one :cidade, through: :logradouro
  has_one :estado, through: :logradouro
  has_many :conexoes
  has_many :contratos
  has_one_attached :rg_imagem
  usar_como_cnpj :cnpj
  usar_como_cpf :cpf

  delegate :endereco, to: :logradouro, prefix: :logradouro

  enum tipo: {"Pessoa Física" => 1, "Pessoa Jurídica" => 2}

  def endereco
    logradouro.nome + ', ' + numero + ' ' + complemento
  end

  def idade
    ((Time.zone.now - nascimento.to_time) / 1.year.seconds).floor
  end

  def cpf_cnpj
    if cpf.numero.present?
      cpf.to_s.gsub(/[^0-9 ]/, '')
    else
      cnpj.to_s.gsub(/[^0-9 ]/, '')
    end
  end

  def tipo_documento
    if tipo == "Pessoa Física"
      "CPF"
    else
      "CNPJ"
    end
  end

  def rg_ie
    rg.present? ? self.rg : self.ie
  end

  def assinante?
    conexoes.count > 0
  end

end
