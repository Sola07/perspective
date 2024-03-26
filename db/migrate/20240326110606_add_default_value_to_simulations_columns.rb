class AddDefaultValueToSimulationsColumns < ActiveRecord::Migration[7.1]
  def up
    change_column_default :simulations, :prix_du_bien, from: nil, to: 0
    change_column_default :simulations, :prix_travaux_cont, from: nil, to: 0
    change_column_default :simulations, :prix_travaux_renov, from: nil, to: 0
    change_column_default :simulations, :achat_meubles, from: nil, to: 0
    change_column_default :simulations, :frais_achat, from: nil, to: 0
    change_column_default :simulations, :apport, from: nil, to: 0
    change_column_default :simulations, :duree_credit_an, from: nil, to: 0
    change_column_default :simulations, :taux_interet, from: nil, to: 0
    change_column_default :simulations, :taux_assurance, from: nil, to: 0
    change_column_default :simulations, :loyer_hc, from: nil, to: 0
    change_column_default :simulations, :taxe_fonciere, from: nil, to: 0
    change_column_default :simulations, :charges_locatives, from: nil, to: 0
    change_column_default :simulations, :autres_charges, from: nil, to: 0
    change_column_default :simulations, :revenu_net_global, from: nil, to: 0
    change_column_default :simulations, :name, from: nil, to: "Ma simulation"

    change_column_null :simulations, :prix_du_bien, false
    change_column_null :simulations, :prix_travaux_cont, false
    change_column_null :simulations, :prix_travaux_renov, false
    change_column_null :simulations, :achat_meubles, false
    change_column_null :simulations, :frais_achat, false
    change_column_null :simulations, :apport, false
    change_column_null :simulations, :duree_credit_an, false
    change_column_null :simulations, :taux_interet, false
    change_column_null :simulations, :taux_assurance, false
    change_column_null :simulations, :loyer_hc, false
    change_column_null :simulations, :taxe_fonciere, false
    change_column_null :simulations, :charges_locatives, false
    change_column_null :simulations, :autres_charges, false
    change_column_null :simulations, :revenu_net_global, false
    change_column_null :simulations, :name, false
  end

  def down
    change_column_default :simulations, :prix_du_bien, from: 0, to: nil
    change_column_default :simulations, :prix_travaux_cont, from: 0, to: nil
    change_column_default :simulations, :prix_travaux_renov, from: 0, to: nil
    change_column_default :simulations, :achat_meubles, from: 0, to: nil
    change_column_default :simulations, :frais_achat, from: 0, to: nil
    change_column_default :simulations, :apport, from: 0, to: nil
    change_column_default :simulations, :duree_credit_an, from: 0, to: nil
    change_column_default :simulations, :taux_interet, from: 0, to: nil
    change_column_default :simulations, :taux_assurance, from: 0, to: nil
    change_column_default :simulations, :loyer_hc, from: 0, to: nil
    change_column_default :simulations, :charges_locatives, from: 0, to: nil
    change_column_default :simulations, :taxe_fonciere, from: 0, to: nil
    change_column_default :simulations, :autres_charges, from: 0, to: nil
    change_column_default :simulations, :revenu_net_global, from: 0, to: nil
    change_column_default :simulations, :name, from: "Ma simulation", to: nil

    change_column_null :simulations, :prix_du_bien, true
    change_column_null :simulations, :prix_travaux_cont, true
    change_column_null :simulations, :prix_travaux_renov, true
    change_column_null :simulations, :achat_meubles, true
    change_column_null :simulations, :frais_achat, true
    change_column_null :simulations, :apport, true
    change_column_null :simulations, :duree_credit_an, true
    change_column_null :simulations, :taux_interet, true
    change_column_null :simulations, :taux_assurance, true
    change_column_null :simulations, :loyer_hc, true
    change_column_null :simulations, :taxe_fonciere, true
    change_column_null :simulations, :charges_locatives, true
    change_column_null :simulations, :autres_charges, true
    change_column_null :simulations, :revenu_net_global, true
    change_column_null :simulations, :name, true
  end
end
