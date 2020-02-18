class AddIndexToFatura < ActiveRecord::Migration[5.2]
  def change
    add_index :faturas, [:pagamento_perfil_id, :nossonumero]
  end
end
