# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'

module Autentique
  HTTP = GraphQL::Client::HTTP.new('https://api.autentique.com.br/v2/graphql') do
    def headers(_context)
      { "Authorization": "Bearer #{Rails.application.credentials.autentique_key}" }
    end
  end
  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
  ResgatarDocumento = Autentique::Client.parse <<-'GRAPHQL'
    query($id: UUID!) {
      document(id: $id) {
        id
        name
        refusable
        sortable
        created_at
        files { original signed }
        signatures {
          public_id
          name
          email
          created_at
          action { name }
          link { short_link }
          user { id name email }
          email_events {
            sent
            opened
            delivered
            refused
            reason
          }
          viewed { ...event }
          signed { ...event }
          rejected { ...event }
        }
      }
    }

    fragment event on Event {
      ip
      port
      reason
      created_at
      geolocation {
        country
        countryISO
        state
        stateISO
        city
        zipcode
        latitude
        longitude
      }
    }
  GRAPHQL

  CriarDocumento = Autentique::Client.parse <<-'GRAPHQL'
    mutation(
      $document: DocumentInput!,
      $signers: [SignerInput!]!,
      $file: Upload!
    ) {
      createDocument(
        document: $document,
        signers: $signers,
        file: $file
      ) {
        id
        name
        refusable
        sortable
        created_at
        signatures {
          public_id
          name
          email
          created_at
          action { name }
          link { short_link }
          user { id name email }
        }
      }
    }
  GRAPHQL

  DocumentosComPendencia = Autentique::Client.parse <<-'GRAPHQL'
    query {
      documents(status: PENDING, limit: 60, page: 1) {
        total
        data {
          id
          name
          refusable
          sortable
          created_at
          signatures {
            public_id
            name
            email
            created_at
            action { name }
            link { short_link }
            user { id name email }
            viewed { created_at }
            signed { created_at }
            rejected { created_at }
          }
          files { original signed }
        }
      }
    }
  GRAPHQL

end
