class CreateServidores < ActiveRecord::Migration[5.2]
  def change
    create_table :servidores do |t|
      t.string :nome
      t.integer :ip
      t.string :usuario
      t.string :senha
      t.integer :api_porta
      t.integer :ssh_porta
      t.integer :snmp_porta
      t.string :snmp_comunidade

      t.timestamps
    end
  end
end
