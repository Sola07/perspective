class Simulation < ApplicationRecord
  belongs_to :user
 # taux de vacance locative (en %)
  TX_VAC = 0.02
  # taux d'indexation annuelle des loyers (en %)
  TX_IND_AN_LOY = 0.01
  # taux d'indexation annuelle des charges(en %)
  TX_IND_AN_CH = 0.01

  def tx(number)
    number / 100
  end
# ------------------ recettes locatives -------------

# loyers charges comprises
  def loyer_cc
    loyer_hc + (charges_locatives / 12 )
  end

  # def loyer_an
  #   loyer_cc * 12
  # end

# recettes locatives
  def recette_loc
    return ((self.loyer_cc * 12) * (1 - TX_VAC))
  end

# ------------------ Acquisition du bien -------------
# frais de notaire

  def frais_notaire

# droit d'enregistrement = droix départementale (4.5%) + taxe communale(1.2%) + frais d'assiette du droit départementale (2.7%)

    droit_enregist = (prix_du_bien * 0.045) + (prix_du_bien * 0.012) + (0.0237 * (prix_du_bien * 0.045))

# frais et débours annexes = frais de formalités, copies et débours
# + contributions de sécurité immobiliėre

    frais_deb_annexes = 1200 + (prix_du_bien * 0.001)

# émoluments du notaire

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

# montant total de l'acquisition

  def total_acq
    self.frais_notaire + prix_du_bien + prix_travaux_cont + prix_travaux_renov + achat_meubles + frais_achat
  end
# ------------------- Banque -------------------

# montant du crédit

  def mont_cre
    self.total_acq - apport
  end

# durée du crédit en mois

  def duree_m
    duree_credit_an * 12
  end

# mensualités hors assurance

  def mens_ss_ass
    self.mont_cre * (tx(taux_interet ) / 12) * ((1+(tx(taux_interet)/12)) ** self.duree_m) / ((1 + (tx(taux_interet)/12)) ** 240 - 1 )
  end

# mensualités avec assurance

  def mens_ass
    ((self.mont_cre * tx(taux_assurance)) / 12) + self.mens_ss_ass
  end

# coût de l'assurance mensuel

  def cout_ass_m
    (self.mont_cre * tx(taux_assurance)) / 12
  end

# remboursement la premiēre année

  def remb_y_one
    mens_ass * 12
  end

# coût total du crédit

  def total_cre
    (self.mens_ss_ass * 12 + tx(taux_assurance) * self.mont_cre) * duree_credit_an - self.mont_cre
  end

# coût total de l'assurance

  def total_ass
    self.cout_ass_m * self.duree_m
  end

# coût mensuel de l'assurance crédit

  def ass_cr
    (self.mens_ass - self.mens_ss_ass) * 12
  end

# taux d'intérêt mensuel

  def tx_int_m
    tx(taux_interet / 12)
  end

# ------------------- charges -------------------

# def intérêt d'emprunt mensuel // pas ouf calculs à revoir

  def int_emp_m(mont_cre, tx_int_m, duree_m)

    interets_mensuels = []
    capital_restant = 0
    capital_remb = 0

    duree_m.times do |mois|
      interets = mont_cre * tx_int_m
      capital_remb = mens_ss_ass - interets
      mont_cre -= capital_remb
      interets_mensuels << interets
      mont_cre -= interets
    end

    return interets_mensuels

  end
# -----------------------------------------------

# charges annuelles totales

  def charg_an
    (self.cout_ass_m * 12) + (int_emp_m(self.mont_cre, self.tx_int_m, self.duree_m).first(12).sum ) + taxe_fonciere + (charges_locatives)
  end
#-------------------------------------------------
# ------------------ bilan mensuel ---------------
#-------------------------------------------------

# bilan mesuel avant imposition

  def bilan_me_av_impots
    (recette_loc / 12) - (charg_an / 12)
  end

# cash mensuel avant imposition

  def cash_me_av_impots
    bilan_me_av_impots - mens_ss_ass + (int_emp_m(self.mont_cre, self.tx_int_m, self.duree_m)[0])
  end

#-------------------------------------------------
# ------------------- rendements -----------------
#-------------------------------------------------

  def rend_brut
    ((loyer_hc * 12 * ( 1 - TX_VAC )) / total_acq) * 100
  end

  def rend_net
    ((loyer_hc * 12 * (1 - TX_VAC) - charg_an) / total_acq) * 100
  end

#-------------------------------------------------
# ------------------- Fiscalité ------------------
#-------------------------------------------------

# revenu net imposable

  def revenu_net_impo
    revenu_net_global * 0.9
  end

# impôts à payer

  def impot
    impot_rev = 0
    if revenu_net_impo <= 10777
      impot_rev = 0
    elsif revenu_net_impo <= 27478
      impot_rev = (revenu_net_impo - 10778) * 0.11
    elsif revenu_net_impo <= 78570
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo - 27479) * 0.30)
    elsif revenu_net_impo <= 168994
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo - 27479) * 0.30) + ((revenu_net_impo - 78571) * 0.41)
    else
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo - 27479) * 0.30) + ((revenu_net_impo - 78571) * 0.41) + ((revenu_net_impo - 168995) * 0.45)
    end

    return impot_rev

  end
#-------------------------------------------------
# ---------------- LMNP MICRO - BIC --------------

  # abattement de 50 % (charges deductibles)

  def abatt_50_lmnp_mb
    recette_loc * 0.5
  end

  # revenus bic imposables

  def rev_bic_impos_lmnp_mb
    recette_loc -  abatt_50_lmnp_mb
  end

  # impôts CSG-CRDS

  def imp_csg_lmnp_mb
    rev_bic_impos_lmnp_mb * 0.172
  end

  # impôt sur le revenu corrigé

  def imp_rev_corr_lmnp_mb
    impot_rev = 0
    if revenu_net_impo + rev_bic_impos_lmnp_mb <= 10777
      impot_rev = 0
    elsif revenu_net_impo + rev_bic_impos_lmnp_mb <= 27478
      impot_rev = (revenu_net_impo + rev_bic_impos_lmnp_mb - 10778) * 0.11
    elsif revenu_net_impo + rev_bic_impos_lmnp_mb <= 78570
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo + rev_bic_impos_lmnp_mb - 27479) * 0.30)
    elsif revenu_net_impo + rev_bic_impos_lmnp_mb <= 168994
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo + rev_bic_impos_lmnp_mb - 27479) * 0.30) + ((revenu_net_impo + rev_bic_impos_lmnp_mb - 78571) * 0.41)
    else
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo + rev_bic_impos_lmnp_mb - 27479) * 0.30) + ((revenu_net_impo + rev_bic_impos_lmnp_mb - 78571) * 0.41) + ((revenu_net_impo + rev_bic_impos_lmnp_mb - 168995) * 0.45)
    end
    return impot_rev
  end

# montant net de l'impôt (impôt corrigé + impôts CSG-CRDS)

  def impot_net_lmnp_mb
    imp_rev_corr_lmnp_mb + imp_csg_lmnp_mb
  end

# ------------------ Bilan LMNP MB ---------------
#-------------------------------------------------

 # charges deductibles de 50 % (charges deductibles)

def char_deduct_lmnp_mb
  abatt_50_lmnp_mb
end

# coût impot

  def cout_imp_lmnp_mb
    impot_net_lmnp_mb - impot
  end

#cash mensuel aprēs impôts

  def cash_mens_ap_imp_lmnp_mb
    (recette_loc - (taxe_fonciere + charges_locatives + autres_charges) - (mens_ss_ass * 12 + cout_ass_m * 12 ) - (cout_imp_lmnp_mb)) / 12
  end

# rentabilité nette

  def rent_net_lmnp_mb

    ((loyer_hc * 12 * (1 - TX_VAC) - charg_an - (impot_net_lmnp_mb - impot) ) / total_acq) * 100
  end

end
