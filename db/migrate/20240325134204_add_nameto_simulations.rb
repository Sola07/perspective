class AddNametoSimulations < ActiveRecord::Migration[7.1]
  def change
    add_column :simulations, :name, :string
  end
end
