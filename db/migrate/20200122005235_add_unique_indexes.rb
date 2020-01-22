class AddUniqueIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :plano_verificar_atributos, [:plano_id, :atributo], unique: true
    add_index :plano_enviar_atributos, [:plano_id, :atributo], unique: true
    add_index :planos, [:nome], unique: true
    add_index :estados, [:nome], unique: true
    add_index :cidades, [:estado_id, :nome], unique: true
  end
end
