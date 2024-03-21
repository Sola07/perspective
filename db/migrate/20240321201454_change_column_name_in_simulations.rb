class ChangeColumnNameInSimulations < ActiveRecord::Migration[7.1]
  def change
    rename_column :simulations, :revenu_net_impo, :revenu_net_global
  end
end
