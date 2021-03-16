class FaturasCancelar < ActiveRecord::Migration[5.2]
  def change
    add_column :faturas, :cancelamento, :datetime
  end
end
