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

ActiveRecord::Schema.define(version: 2020_05_17_100830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "mac"
    t.integer "tipo"
    t.bigint "caixa_id"
    t.integer "porta"
    t.index ["caixa_id"], name: "index_conexoes_on_caixa_id"
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
    t.bigint "pagamento_perfil_id"
    t.index ["pagamento_perfil_id"], name: "index_contratos_on_pagamento_perfil_id"
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
    t.bigint "pagamento_perfil_id"
    t.decimal "juros_recebidos"
    t.decimal "desconto_concedido"
    t.integer "banco"
    t.integer "agencia"
    t.bigint "retorno_id"
    t.bigint "registro_id"
    t.bigint "baixa_id"
    t.index ["baixa_id"], name: "index_faturas_on_baixa_id"
    t.index ["contrato_id"], name: "index_faturas_on_contrato_id"
    t.index ["liquidacao"], name: "index_faturas_on_liquidacao"
    t.index ["meio_liquidacao", "liquidacao"], name: "index_faturas_on_meio_liquidacao_and_liquidacao"
    t.index ["pagamento_perfil_id", "nossonumero"], name: "index_faturas_on_pagamento_perfil_id_and_nossonumero"
    t.index ["pagamento_perfil_id"], name: "index_faturas_on_pagamento_perfil_id"
    t.index ["registro_id"], name: "index_faturas_on_registro_id"
    t.index ["retorno_id"], name: "index_faturas_on_retorno_id"
    t.index ["vencimento"], name: "index_faturas_on_vencimento"
  end

  create_table "fibra_caixas", force: :cascade do |t|
    t.string "nome"
    t.bigint "fibra_rede_id"
    t.integer "capacidade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fibra_rede_id"], name: "index_fibra_caixas_on_fibra_rede_id"
  end

  create_table "fibra_redes", force: :cascade do |t|
    t.string "nome"
    t.bigint "ponto_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ponto_id"], name: "index_fibra_redes_on_ponto_id"
  end

  create_table "logradouros", force: :cascade do |t|
    t.string "nome"
    t.integer "bairro_id"
    t.string "cep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bairro_id"], name: "index_logradouros_on_bairro_id"
  end

  create_table "nf21_itens", force: :cascade do |t|
    t.bigint "nf21_id"
    t.text "item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nf21_id"], name: "index_nf21_itens_on_nf21_id"
  end

  create_table "nf21s", force: :cascade do |t|
    t.bigint "fatura_id"
    t.date "emissao"
    t.integer "numero"
    t.decimal "valor", precision: 8, scale: 2
    t.text "cadastro"
    t.text "mestre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fatura_id"], name: "index_nf21s_on_fatura_id"
  end

  create_table "pagamento_perfis", force: :cascade do |t|
    t.string "nome"
    t.integer "tipo"
    t.integer "cedente"
    t.integer "agencia"
    t.integer "conta"
    t.string "carteira"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "banco"
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
    t.bigint "acctinterval"
    t.bigint "acctsessiontime"
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

  create_table "retornos", force: :cascade do |t|
    t.bigint "pagamento_perfil_id"
    t.date "data"
    t.integer "sequencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pagamento_perfil_id"], name: "index_retornos_on_pagamento_perfil_id"
  end

  create_table "servidores", force: :cascade do |t|
    t.string "nome"
    t.string "usuario"
    t.string "senha"
    t.integer "api_porta"
    t.integer "ssh_porta"
    t.integer "snmp_porta"
    t.string "snmp_comunidade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.inet "ip"
    t.boolean "ativo"
    t.boolean "up"
    t.string "radius_secret"
    t.integer "radius_porta"
    t.string "versao"
    t.string "equipamento"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

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
    t.string "primeiro_nome"
    t.string "nome_completo"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cidades", "estados"
  add_foreign_key "contratos", "pagamento_perfis"
  add_foreign_key "faturas", "pagamento_perfis"
  add_foreign_key "faturas", "retornos", column: "baixa_id"
  add_foreign_key "faturas", "retornos", column: "registro_id"
  add_foreign_key "fibra_caixas", "fibra_redes"
  add_foreign_key "fibra_redes", "pontos"
end
