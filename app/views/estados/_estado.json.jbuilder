# frozen_string_literal: true

json.extract! estado, :id, :sigla, :nome, :ibge, :created_at, :updated_at
json.url estado_url(estado, format: :json)
