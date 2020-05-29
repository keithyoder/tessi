class GerarNotasJob < ApplicationJob
    queue_as :default
  
    def perform
      Fatura.where('nf21 is null and liquidacao between ? and ?', 1.week.ago, 1.day.ago) do | fatura |
        next_nf = Nf21.maximum(:numero) + 1
        nf = fatura.nf21.create(emissao: fatura.liquidacao, numero: next_nf)
        nf.gerar_registros
        nf.save!
      end
    end
  end
