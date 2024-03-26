require "faker"

3.times do
  user = User.new(
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
  user.save
end

user2 = User.new(
  email: "toto@gmail.com",
  password: "tototo",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name
)
user2.save

3.times do
  simulation = Simulation.new(
    prix_du_bien: Faker::Number.number(digits: 6),
    prix_travaux_cont: Faker::Number.number(digits: 5),
    prix_travaux_renov: Faker::Number.number(digits: 4),
    achat_meubles: Faker::Number.number(digits: 4),
    frais_achat: Faker::Number.number(digits: 4),
    apport: Faker::Number.number(digits: 5),
    duree_credit_an: 25,
    taux_interet: Faker::Number.decimal(l_digits: 2),
    taux_assurance: Faker::Number.decimal(l_digits: 2),
    loyer_hc: Faker::Number.number(digits: 4),
    taxe_fonciere: Faker::Number.number(digits: 4),
    charges_locatives: Faker::Number.number(digits: 3),
    autres_charges: Faker::Number.number(digits: 3),
    revenu_net_global: Faker::Number.number(digits: 5),
    user_id: (1..3).to_a.sample
  )
  simulation.save!
end
