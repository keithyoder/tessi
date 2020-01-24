class Ponto < ApplicationRecord
  belongs_to :servidor
  has_many :conexoes
  
  enum tecnologia: {:Radio => 1, :Fibra => 2}
  enum sistema: {:Ubnt => 1, :Mikrotik => 2, :Chima => 3, :Outro => 4}

  def self.to_csv
    attributes = %w{id nome ip sistema tecnologia}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |estado|
        csv << attributes.map{ |attr| estado.send(attr) }
      end
    end
  end

end
