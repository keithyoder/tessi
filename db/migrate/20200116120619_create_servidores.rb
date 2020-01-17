class CreateServidores < ActiveRecord::Migration[5.2]
  def change
    add_column :servidores, :ativo, :boolean  
    add_column :servidores, :up, :boolean  
  end
end
