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

ActiveRecord::Schema.define(version: 2020_01_23_143339) do

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
    t.index ["estado_id", "nome"], name: "index_cidades_on_estado_id_and_nome", unique: true
    t.index ["estado_id"], name: "index_cidades_on_estado_id"
  end

  create_table "conexoes", force: :cascade do |t|
    t.integer "pessoa_id"
    t.integer "plano_id"
    t.integer "ponto_id"
    t.string "ip"
    t.string "velocidade"
    t.boolean "bloqueado"
    t.boolean "auto_bloqueio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "observacao"
    t.string "usuario"
    t.string "senha"
    t.index ["pessoa_id"], name: "index_conexoes_on_pessoa_id"
    t.index ["plano_id"], name: "index_conexoes_on_plano_id"
    t.index ["ponto_id"], name: "index_conexoes_on_ponto_id"
  end

  create_table "estados", force: :cascade do |t|
    t.string "sigla"
    t.string "nome"
    t.integer "ibge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_estados_on_nome", unique: true
  end

  create_table "logradouros", force: :cascade do |t|
    t.string "nome"
    t.integer "bairro_id"
    t.string "cep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bairro_id"], name: "index_logradouros_on_bairro_id"
  end

  create_table "pessoas", force: :cascade do |t|
    t.string "nome"
    t.integer "tipo"
    t.string "cpf"
    t.string "cnpj"
    t.string "rg"
    t.string "ie"
    t.date "nascimento"
    t.integer "logradouro_id"
    t.string "numero"
    t.string "complemento"
    t.string "nomemae"
    t.string "email"
    t.string "telefone1"
    t.string "telefone2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logradouro_id"], name: "index_pessoas_on_logradouro_id"
    t.index ["nome"], name: "index_pessoas_on_nome"
  end

  create_table "plano_enviar_atributos", force: :cascade do |t|
    t.integer "plano_id"
    t.string "atributo"
    t.string "op"
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plano_id", "atributo"], name: "index_plano_enviar_atributos_on_plano_id_and_atributo", unique: true
    t.index ["plano_id"], name: "index_plano_enviar_atributos_on_plano_id"
  end

  create_table "plano_verificar_atributos", force: :cascade do |t|
    t.integer "plano_id"
    t.string "atributo"
    t.string "op"
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plano_id", "atributo"], name: "index_plano_verificar_atributos_on_plano_id_and_atributo", unique: true
    t.index ["plano_id"], name: "index_plano_verificar_atributos_on_plano_id"
  end

  create_table "planos", force: :cascade do |t|
    t.string "nome"
    t.decimal "mensalidade", precision: 8, scale: 2
    t.integer "upload"
    t.integer "download"
    t.boolean "burst"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_planos_on_nome", unique: true
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
