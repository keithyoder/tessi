# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_20_202548) do

  create_table "bairros", force: :cascade do |t|
    t.string "nome"
    t.integer "cidade_id"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cidade_id"], name: "index_bairros_on_cidade_id"
  end

  create_table "cidades", force: :cascade do |t|
    t.string "nome"
    t.integer "estado_id"
    t.string "ibge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estado_id"], name: "index_cidades_on_estado_id"
  end

  create_table "estados", force: :cascade do |t|
    t.string "sigla"
    t.string "nome"
    t.integer "ibge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logradouros", force: :cascade do |t|
    t.string "nome"
    t.integer "bairro_id"
    t.string "cep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bairro_id"], name: "index_logradouros_on_bairro_id"
  end

  create_table "planos", force: :cascade do |t|
    t.string "nome"
    t.decimal "mensalidade", precision: 8, scale: 2
    t.integer "upload"
    t.integer "download"
    t.boolean "burst"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pontos", force: :cascade do |t|
    t.string "nome"
    t.integer "sistema"
    t.integer "tecnologia"
    t.integer "servidor_id"
    t.string "ip"
    t.string "usuario"
    t.string "senha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["servidor_id"], name: "index_pontos_on_servidor_id"
  end

# Could not dump table "servidores" because of following StandardError
#   Unknown type 'inet' for column 'ip'

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "role"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
