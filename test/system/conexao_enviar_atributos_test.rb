# frozen_string_literal: true

require 'application_system_test_case'

class ConexaoEnviarAtributosTest < ApplicationSystemTestCase
  setup do
    @conexao_enviar_atributo = conexao_enviar_atributos(:one)
  end

  test 'visiting the index' do
    visit conexao_enviar_atributos_url
    assert_selector 'h1', text: 'Conexao Enviar Atributos'
  end

  test 'creating a Conexao enviar atributo' do
    visit conexao_enviar_atributos_url
    click_on 'New Conexao Enviar Atributo'

    fill_in 'Atributo', with: @conexao_enviar_atributo.atributo
    fill_in 'Conexao', with: @conexao_enviar_atributo.conexao_id
    fill_in 'Op', with: @conexao_enviar_atributo.op
    fill_in 'Valor', with: @conexao_enviar_atributo.valor
    click_on 'Create Conexao enviar atributo'

    assert_text 'Conexao enviar atributo was successfully created'
    click_on 'Back'
  end

  test 'updating a Conexao enviar atributo' do
    visit conexao_enviar_atributos_url
    click_on 'Edit', match: :first

    fill_in 'Atributo', with: @conexao_enviar_atributo.atributo
    fill_in 'Conexao', with: @conexao_enviar_atributo.conexao_id
    fill_in 'Op', with: @conexao_enviar_atributo.op
    fill_in 'Valor', with: @conexao_enviar_atributo.valor
    click_on 'Update Conexao enviar atributo'

    assert_text 'Conexao enviar atributo was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Conexao enviar atributo' do
    visit conexao_enviar_atributos_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Conexao enviar atributo was successfully destroyed'
  end
end
