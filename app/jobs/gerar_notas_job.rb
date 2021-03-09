class GerarNotasJob < ApplicationJob
  queue_as :default

  def perform
    range = 1.week.ago..1.day.ago
    Fatura.notas_a_emitir(range) do |fatura|
      next_nf = Nf21.maximum(:numero) + 1
      fatura.nf21.create!(emissao: fatura.liquidacao, numero: next_nf)
    end
  end
end
