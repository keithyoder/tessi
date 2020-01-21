class Ponto < ApplicationRecord
  belongs_to :servidor
  enum tecnologia: {:Radio => 1, :Fibra => 2}
  enum sistema: {:Ubnt => 1, :Mikrotik => 2, :Chima => 3}
end
