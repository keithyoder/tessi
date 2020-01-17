class Plano < ApplicationRecord
  #def mensalidade
  #  ActionController::Base.helpers.number_to_currency(self[:mensalidade])
  #end

  def velocidade
    self.download.to_s + 'M ▼ / ' + self.upload.to_s + 'M ▲'
  end
end
