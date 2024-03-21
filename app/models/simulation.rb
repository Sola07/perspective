class Simulation < ApplicationRecord
  belongs_to :user

  TX_VAC = 0.02
  TX_IND_AN_LOY = 0.01
  TX_IND_AN_CH = 0.01

  def loyer_cc
    loyer_hc + (charges_locatives / 12 )
  end

  def recette_loc
    return ((self.loyer_cc * 12) * (1 - TX_VAC))
  end

  def frais_notaire
    droit_enregist = (prix_du_bien * 0.045) + (prix_du_bien * 0.012) + (0.0237 * (prix_du_bien * 0.045))
    frais_deb_annexes = 1200 + (prix_du_bien * 0.001)
    emol_not = 0

    if prix_du_bien >= 6500
      emol_not += 6500 * 0.0387
    else
      emol_not += prix_du_bien * 0.0387
    end

    if prix_du_bien >= 17000
      emol_not += (17000 - 6500) * 0.01596
    else
      emol_not += (prix_du_bien - 6500) * 0.001596
    end

    if prix_du_bien >= 60000
      emol_not += (60000 - 17000) * 0.01064
    else
      emol_not += (prix_du_bien - 17000) * 0.01064
    end
    emol_not = (emol_not * 0.2) + emol_not

    return total = droit_enregist + frais_deb_annexes + emol_not
  end

  def total_acq
    self.frais_notaire + prix_du_bien + prix_travaux_cont + prix_travaux_renov + achat_meubles + frais_achat
  end

  def mont_cre
    self.total_acq - apport
  end

  def duree_m
    duree_credit_an * 12
  end

  def tx(number)
    number / 100
  end

  def mens_ss_ass
    self.mont_cre * (tx(taux_interet ) / 12) * ((1+(tx(taux_interet)/12)) ** self.duree_m) / ((1 + (tx(taux_interet)/12)) ** 240 - 1 )
  end

  def mens_ass
    ((self.mont_cre * tx(taux_assurance)) / 12) + self.mens_ss_ass
  end

  def cout_ass_m
    (self.mont_cre * tx(taux_assurance)) / 12
  end

  def remb_y_one
    mens_ass * 12
  end

  def total_cre
    (self.mens_ss_ass * 12 + tx(taux_assurance) * self.mont_cre) * duree_credit_an - self.mont_cre
  end

  def total_ass
    self.cout_ass_m * self.duree_m
  end

  def ass_cr
    (self.mens_ass - self.mens_ss_ass) * 12
  end

  def tx_int_m
    taux_interet / 12
  end

  def int_emp
    mont_cre * tx(tx_int_m)
  end

end
