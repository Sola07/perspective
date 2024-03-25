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
    (self.cout_ass_m * 12) + (int_emp_m(self.mont_cre, self.tx_int_m, self.duree_m).first(12).sum ) + taxe_fonciere + charges_locatives
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
#------------------------------------------------------
# ---------------- LMNP MICRO - BIC -------------------

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

# ------------------ Bilan LMNP MB --------------------
#------------------------------------------------------

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



#------------------------------------------------------
# ---------------- LMNP REGIME REEL -------------------

# charges + travaux
  def charges_trav_lmnp_rr
    ass_cr + taxe_fonciere + charges_locatives + autres_charges + prix_travaux_renov
  end

# calculs des intérêts d'emprunt pour l'année 1


  def interets_annuel_1
    int_emp_m(mont_cre, tx_int_m, duree_m).first(12).sum
  end


# calcul des dotations aux amortissements => amortissement du bien, des frais d'acquisiton, travaux et meubles

  def amortissement_lmnp_rr

    # base du bien amortissable = prix du bien - 2% du prix du bien
    base_bien_amor = prix_du_bien - (prix_du_bien * 0.2)

    amor_bien = (base_bien_amor * 0.4/50) + (base_bien_amor * 0.2 / 20) + (base_bien_amor * 0.2 / 20) + (base_bien_amor * 0.2 / 5)
    amor_trav = prix_travaux_cont * 0.667
    amor_meubl = achat_meubles * 0.2
    amor_frais_ac = (frais_notaire + frais_achat) / 10

    return amor_frais_ac + amor_bien + amor_meubl + amor_trav
  end

# resultat // calculs des deficits industriels et commerciaux

  def deficit_ind_comerc_lmnp_rr
  recette_loc - interets_annuel_1 - charges_trav_lmnp_rr - amortissement_lmnp_rr
  end
# revenus BIC imposable

  def reven_imposable_lmnp_rr
    if deficit_ind_comerc_lmnp_rr < 0
      0
    else
      deficit_ind_comerc_lmnp_rr
    end
  end

# Deficits imputables sur revenus BIC N+1

  def def_imp_rev_n1
    if reven_imposable_lmnp_rr <= 0
      deficit_ind_comerc_lmnp_rr
    end
  end

# impôts CSG-CRDS

  def imp_csg_lmnp_rr
    reven_imposable_lmnp_rr * 0.172
  end

# impots sur le revenu corrigé

  def imp_rev_corr_lmnp_rr
    impot_rev = 0
    if revenu_net_impo + reven_imposable_lmnp_rr <= 10777
      impot_rev = 0
    elsif revenu_net_impo + reven_imposable_lmnp_rr <= 27478
      impot_rev = (revenu_net_impo + reven_imposable_lmnp_rr - 10778) * 0.11
    elsif revenu_net_impo + reven_imposable_lmnp_rr <= 78570
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo + reven_imposable_lmnp_rr - 27479) * 0.30)
    elsif revenu_net_impo + reven_imposable_lmnp_rr <= 168994
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo + reven_imposable_lmnp_rr - 27479) * 0.30) + ((revenu_net_impo + reven_imposable_lmnp_rr - 78571) * 0.41)
    else
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_net_impo + reven_imposable_lmnp_rr - 27479) * 0.30) + ((revenu_net_impo + reven_imposable_lmnp_rr - 78571) * 0.41) + ((revenu_net_impo + reven_imposable_lmnp_rr - 168995) * 0.45)
    end
    return impot_rev
  end

## montant net de l'impôt (impôt corrigé + impôts CSG-CRDS)

  def impot_net_lmnp_rr
    imp_rev_corr_lmnp_rr + imp_csg_lmnp_rr
  end

# -------------- Bilan LMNP Regime Reel ---------------
#------------------------------------------------------

# charges deductibles

  def amor_bien_lmp_rr
    amortissement_lmnp_rr
  end

  def char_deduct_lmnp_rr
    charges_trav_lmnp_rr + amortissement_lmnp_rr +  interets_annuel_1
  end

# coût impot

  def cout_imp_lmnp_rr
    impot_net_lmnp_rr - impot
  end

#cash mensuel aprēs impôts

  def cash_mens_ap_imp_lmnp_rr
    (recette_loc - (taxe_fonciere + charges_locatives + autres_charges) - (mens_ss_ass * 12 + cout_ass_m * 12 ) - (cout_imp_lmnp_rr)) / 12
  end

# rentabilité nette

  def rent_net_lmnp_rr
    ((loyer_hc * 12 * (1 - TX_VAC) - charg_an - (impot_net_lmnp_rr - impot) ) / total_acq) * 100
  end


#------------------------------------------------------
# --------------------- SCI IR ------------------------

# resultats fonciers de la SCI (bénéfices si > 0)

  def result_foncier_sci_ir
    recette_loc - interets_annuel_1 - charges_trav_lmnp_rr
  end


# deficits fonciers de la SCI si resultats fonciers < 0

  def deficit_fonc_sci_ir
    if result_foncier_sci_ir < 0
      result_foncier_sci_ir
    else
      0
    end
  end

# benefices fonciers de la SCI si resultats fonciers > 0

  def benefic_fonc_sci_ir
    if result_foncier_sci_ir > 0
      result_foncier_sci_ir
    else
      0
    end
  end

# deficits imputables sur le revenu globalde

  def deficit_imput_rev_global_sci_ir
    lim_defi_imput_1_an = 10700
    if deficit_fonc_sci_ir > 0
      deficit_fonc_sci_ir
    else
      lim_defi_imput_1_an
    end
  end

# deficits imputables sur le revenu foncier n +1

  def deficit_imput_rev_fonc_n1_sci_ir
    if deficit_fonc_sci_ir < -10700
      deficit_fonc_sci_ir + 10700
    else
      0
    end
  end

# impôts CSG-CRDS

  def imp_csg_sci_ir

    if result_foncier_sci_ir <= 0
      0
    else
      result_foncier_sci_ir * 0.172
    end
  end

# revenus révisés

  def revenu_rev_sci_ir
    if result_foncier_sci_ir < 0
      revenu_net_impo - deficit_imput_rev_global_sci_ir
    else
      revenu_net_impo + result_foncier_sci_ir
    end
  end

# impots sur le revenu corrigé

  def imp_rev_corr_sci_ir
    impot_rev = 0
    if revenu_rev_sci_ir <= 10777
      impot_rev = 0
    elsif revenu_rev_sci_ir <= 27478
      impot_rev = (revenu_rev_sci_ir - 10778) * 0.11
    elsif revenu_rev_sci_ir <= 78570
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_rev_sci_ir - 27479) * 0.30)
    elsif revenu_rev_sci_ir <= 168994
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_rev_sci_ir - 27479) * 0.30) + ((revenu_rev_sci_ir - 78571) * 0.41)
    else
      impot_rev = ((27478 - 10778) * 0.11) + ((revenu_rev_sci_ir - 27479) * 0.30) + ((revenu_rev_sci_ir - 78571) * 0.41) + ((revenu_rev_sci_ir - 168995) * 0.45)
    end
    return impot_rev
  end

# Montant net de l'impot revise + impôts CSG-CRDS

  def impot_net_sci_ir
    imp_csg_sci_ir + imp_rev_corr_sci_ir
  end

# Tresorie annuelle de la SCI la premiere annee

  def treso_an_sci_ir_an1
    recette_loc - ((taxe_fonciere + charges_locatives + autres_charges)) - (mens_ass * 12)
  end
# ----------------Bilan SCI IR ------------------------
#------------------------------------------------------

# coût impot de l'investissement

  def cout_imp_sci_ir
    imp_rev_corr_sci_ir - impot + imp_csg_sci_ir
  end

# cash mensuel aprēs imposition

  def cash_mens_ap_imp_sci_ir
    (treso_an_sci_ir_an1 - cout_imp_sci_ir) / 12
  end

# charges deductibles

  def char_deduct_sci_ir
    charges_trav_lmnp_rr +  interets_annuel_1
  end

# rentabilité nette

  def rent_net_sci_ir
    ((loyer_hc * 12 * (1 - TX_VAC) - charg_an - (impot_net_sci_ir - impot) ) / total_acq) * 100
  end

#------------------------------------------------------
# --------------------- SCI IS-------------------------

  def amortissement_sci_is

# base du bien amortissable = prix du bien - 2% du prix du bien

    base_bien_amor = prix_du_bien - (prix_du_bien * 0.2)

    amor_bien = (base_bien_amor * 0.4/50) + (base_bien_amor * 0.2 / 20) + (base_bien_amor * 0.2 / 20) + (base_bien_amor * 0.2 / 5)
    amor_trav = prix_travaux_cont * 0.667
    amor_meubl = achat_meubles * 0.2
    amor_frais_ac = (frais_notaire + frais_achat) / 10

    return amor_frais_ac + amor_bien + amor_meubl + amor_trav
  end

  def result_foncier_sci_is
    recette_loc - interets_annuel_1 - charges_trav_lmnp_rr - amortissement_sci_is
  end

# deficits fonciers de la SCI si resultats fonciers < 0

    def deficit_fonc_sci_is
      if result_foncier_sci_is < 0
        result_foncier_sci_is
      else
        0
      end
    end

# benefices fonciers de la SCI si resultats fonciers > 0

    def benef_fonc_sci_is
      if result_foncier_sci_is > 0
        result_foncier_sci_is
      else
        0
      end
    end

    def impot_benef_fonc_sci_is
      if benef_fonc_sci_is > 0
        if benef_fonc_sci_is <= 42500
          benef_fonc_sci_is * 0.15
        else
          42500 * 0.15 + (benef_fonc_sci_is - 42500)* 0.25
        end
      else
        0
      end
    end

    def result_net_sci_is
      result_foncier_sci_is - impot_benef_fonc_sci_is
    end

    def treso_an_sci_is_an1
      recette_loc - ((taxe_fonciere + charges_locatives + autres_charges)) - (mens_ass * 12) - impot_benef_fonc_sci_is
    end

# ----------------Bilan SCI IS ------------------------
#------------------------------------------------------

# coût impot de l'investissement

  def cout_imp_sci_is
    impot_benef_fonc_sci_is
  end

  # cash mensuel aprēs imposition

  def cash_mens_ap_imp_sci_is
    (treso_an_sci_is_an1 - impot_benef_fonc_sci_is) / 12
  end

  # charges deductibles

  def char_deduct_sci_is
    charges_trav_lmnp_rr +  interets_annuel_1 + amortissement_sci_is
  end

  # rentabilité nette

  def rent_net_sci_is
    ((loyer_hc * 12 * (1 - TX_VAC) - charg_an - (impot_benef_fonc_sci_is) ) / total_acq) * 100
  end

end
