# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_26_110606) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "simulations", force: :cascade do |t|
    t.float "prix_du_bien", default: 0.0, null: false
    t.float "prix_travaux_cont", default: 0.0, null: false
    t.float "prix_travaux_renov", default: 0.0, null: false
    t.float "achat_meubles", default: 0.0, null: false
    t.float "frais_achat", default: 0.0, null: false
    t.float "apport", default: 0.0, null: false
    t.integer "duree_credit_an", default: 0, null: false
    t.float "taux_interet", default: 0.0, null: false
    t.float "taux_assurance", default: 0.0, null: false
    t.float "loyer_hc", default: 0.0, null: false
    t.float "taxe_fonciere", default: 0.0, null: false
    t.float "charges_locatives", default: 0.0, null: false
    t.float "autres_charges", default: 0.0, null: false
    t.float "revenu_net_global", default: 0.0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "Ma simulation", null: false
    t.index ["user_id"], name: "index_simulations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "simulations", "users"
end
