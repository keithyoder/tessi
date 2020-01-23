class Ponto < ApplicationRecord
  belongs_to :servidor
  has_many :conexoes
  
  enum tecnologia: {:Radio => 1, :Fibra => 2}
  enum sistema: {:Ubnt => 1, :Mikrotik => 2, :Chima => 3, :Outro => 4}
end
