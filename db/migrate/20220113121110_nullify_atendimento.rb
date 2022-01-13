class NullifyAtendimento < ActiveRecord::Migration[5.2]
  def change
    drop_foreign_key "atendimentos", "conexoes"
    add_foreign_key "atendimentos", "conexoes", on_delete: :nullify
  end
end
