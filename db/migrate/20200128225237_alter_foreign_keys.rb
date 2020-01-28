class AlterForeignKeys < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :conexao_enviar_atributos, :conexao
    add_foreign_key :conexao_enviar_atributos, :conexao, on_delete: :cascade
    remove_foreign_key :conexao_verificar_atributos, :conexao
    add_foreign_key :conexao_verificar_atributos, :conexao, on_delete: :cascade
    remove_foreign_key :plano_enviar_atributos, :plano
    add_foreign_key :plano_enviar_atributos, :plano, on_delete: :cascade
    remove_foreign_key :plano_enviar_atributos, :plano
    add_foreign_key :plano_verificar_atributos, :plano, on_delete: :cascade
    add_index :conexao_verificar_atributos, [:conexao_id, :atributo], unique: true
    add_index :conexao_enviar_atributos, [:conexao_id, :atributo], unique: true
  end
end
