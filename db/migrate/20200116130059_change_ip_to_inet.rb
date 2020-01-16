class ChangeIpToInet < ActiveRecord::Migration[5.2]
  def up
    change_column :servidores, :ip, :inet
  end

  def down
    change_column :servidores, :ip, :integer
  end
end
