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

ActiveRecord::Schema.define(version: 2020_02_05_131023) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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

  create_table "conexao_enviar_atributos", force: :cascade do |t|
    t.integer "conexao_id"
    t.string "atributo"
    t.string "op"
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conexao_id", "atributo"], name: "index_conexao_enviar_atributos_on_conexao_id_and_atributo", unique: true
    t.index ["conexao_id"], name: "index_conexao_enviar_atributos_on_conexao_id"
  end

  create_table "conexao_verificar_atributos", force: :cascade do |t|
    t.integer "conexao_id"
    t.string "atributo"
    t.string "op"
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conexao_id", "atributo"], name: "index_conexao_verificar_atributos_on_conexao_id_and_atributo", unique: true
    t.index ["conexao_id"], name: "index_conexao_verificar_atributos_on_conexao_id"
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
    t.boolean "inadimplente", default: false, null: false
    t.integer "contrato_id"
    t.index ["contrato_id"], name: "index_conexoes_on_contrato_id"
    t.index ["pessoa_id"], name: "index_conexoes_on_pessoa_id"
    t.index ["plano_id"], name: "index_conexoes_on_plano_id"
    t.index ["ponto_id"], name: "index_conexoes_on_ponto_id"
  end

  create_table "contratos", force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.integer "plano_id", null: false
    t.integer "status"
    t.integer "dia_vencimento"
    t.date "adesao"
    t.decimal "valor_instalacao", precision: 8, scale: 2
    t.integer "numero_conexoes", default: 1
    t.date "cancelamento"
    t.boolean "emite_nf", default: true
    t.date "primeiro_vencimento"
    t.integer "prazo_meses", default: 12
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pessoa_id"], name: "index_contratos_on_pessoa_id"
    t.index ["plano_id"], name: "index_contratos_on_plano_id"
  end

  create_table "estados", force: :cascade do |t|
    t.string "sigla"
    t.string "nome"
    t.integer "ibge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_estados_on_nome", unique: true
  end

  create_table "faturas", force: :cascade do |t|
    t.integer "contrato_id"
    t.decimal "valor", null: false
    t.date "vencimento", null: false
    t.string "nossonumero", null: false
    t.integer "parcela", null: false
    t.string "arquivo_remessa"
    t.date "data_remessa"
    t.date "data_cancelamento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "liquidacao"
    t.decimal "valor_liquidacao", precision: 8, scale: 2
    t.date "vencimento_original"
    t.decimal "valor_original", precision: 8, scale: 2
    t.integer "meio_liquidacao"
    t.date "periodo_inicio"
    t.date "periodo_fim"
    t.index ["contrato_id"], name: "index_faturas_on_contrato_id"
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
    t.decimal "desconto", precision: 8, scale: 2
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
    t.string "ssid"
    t.string "frequencia"
    t.integer "canal_tamanho"
    t.string "equipamento"
    t.index ["servidor_id"], name: "index_pontos_on_servidor_id"
  end

  create_table "radacct", primary_key: "radacctid", id: :bigint, default: nil, force: :cascade do |t|
    t.string "acctsessionid", limit: 64, default: "", null: false
    t.string "acctuniqueid", limit: 32, default: "", null: false
    t.string "username", limit: 64, default: "", null: false
    t.string "groupname", limit: 64, default: "", null: false
    t.string "realm", limit: 64, default: ""
    t.string "nasipaddress", limit: 15, default: "", null: false
    t.string "nasportid", limit: 15
    t.string "nasporttype", limit: 32
    t.datetime "acctstarttime"
    t.datetime "acctupdatetime"
    t.datetime "acctstoptime"
    t.integer "acctinterval", limit: 12
    t.integer "acctsessiontime", limit: 12
    t.string "acctauthentic", limit: 32
    t.string "connectinfo_start", limit: 50
    t.string "connectinfo_stop", limit: 50
    t.bigint "acctinputoctets"
    t.bigint "acctoutputoctets"
    t.string "calledstationid", limit: 50, default: "", null: false
    t.string "callingstationid", limit: 50, default: "", null: false
    t.string "acctterminatecause", limit: 32, default: "", null: false
    t.string "servicetype", limit: 32
    t.string "framedprotocol", limit: 32
    t.string "framedipaddress", limit: 15, default: "", null: false
  end

  create_table "radpostauth", force: :cascade do |t|
    t.string "username", limit: 64, default: "", null: false
    t.string "pass", limit: 64, default: "", null: false
    t.string "reply", limit: 32, default: "", null: false
    t.datetime "authdate", null: false
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
