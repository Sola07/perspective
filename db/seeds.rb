require "faker"

Simulation.destroy_all
User.destroy_all


user = User.new(
  email: "toto@gmail.com",
  password: "tototo",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name
)
user.save


simulation = Simulation.new(
  prix_du_bien: 60000,
  prix_travaux_cont: 50000,
  prix_travaux_renov: 0,
  achat_meubles: 0,
  frais_achat: 1500,
  apport: 15000,
  duree_credit_an: 25,
  taux_interet: 4.1,
  taux_assurance: 0.35,
  loyer_hc: 800,
  taxe_fonciere: 1200,
  charges_locatives: 480,
  autres_charges: 0,
  revenu_net_global: 70000,
  user_id: 1
  )
  simulation.save!
