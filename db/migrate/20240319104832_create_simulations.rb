class CreateSimulations < ActiveRecord::Migration[7.1]
  def change
    create_table :simulations do |t|
      t.float :prix_du_bien
      t.float :prix_travaux_cont
      t.float :prix_travaux_renov
      t.float :achat_meubles
      t.float :frais_achat
      t.float :apport
      t.integer :duree_credit_an
      t.float :taux_interet
      t.float :taux_assurance
      t.float :loyer_hc
      t.float :taxe_fonciere
      t.float :charges_locatives
      t.float :autres_charges
      t.float :revenu_net_impo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
