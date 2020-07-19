class AddPontoToRedes < ActiveRecord::Migration[5.2]
  def change
    add_reference :ip_redes, :ponto
  end
end
