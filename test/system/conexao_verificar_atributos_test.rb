# frozen_string_literal: true

require 'application_system_test_case'

class ConexaoVerificarAtributosTest < ApplicationSystemTestCase
  setup do
    @conexao_verificar_atributo = conexao_verificar_atributos(:one)
  end

  test 'visiting the index' do
    visit conexao_verificar_atributos_url
    assert_selector 'h1', text: 'Conexao Verificar Atributos'
  end

  test 'creating a Conexao verificar atributo' do
    visit conexao_verificar_atributos_url
    click_on 'New Conexao Verificar Atributo'

    fill_in 'Atributo', with: @conexao_verificar_atributo.atributo
    fill_in 'Conexao', with: @conexao_verificar_atributo.conexao_id
    fill_in 'Op', with: @conexao_verificar_atributo.op
    fill_in 'Valor', with: @conexao_verificar_atributo.valor
    click_on 'Create Conexao verificar atributo'

    assert_text 'Conexao verificar atributo was successfully created'
    click_on 'Back'
  end

  test 'updating a Conexao verificar atributo' do
    visit conexao_verificar_atributos_url
    click_on 'Edit', match: :first

    fill_in 'Atributo', with: @conexao_verificar_atributo.atributo
    fill_in 'Conexao', with: @conexao_verificar_atributo.conexao_id
    fill_in 'Op', with: @conexao_verificar_atributo.op
    fill_in 'Valor', with: @conexao_verificar_atributo.valor
    click_on 'Update Conexao verificar atributo'

    assert_text 'Conexao verificar atributo was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Conexao verificar atributo' do
    visit conexao_verificar_atributos_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Conexao verificar atributo was successfully destroyed'
  end
end
