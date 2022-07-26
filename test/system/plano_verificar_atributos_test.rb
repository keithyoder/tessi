# frozen_string_literal: true

require 'application_system_test_case'

class PlanoVerificarAtributosTest < ApplicationSystemTestCase
  setup do
    @plano_verificar_atributo = plano_verificar_atributos(:one)
  end

  test 'visiting the index' do
    visit plano_verificar_atributos_url
    assert_selector 'h1', text: 'Plano Verificar Atributos'
  end

  test 'creating a Plano verificar atributo' do
    visit plano_verificar_atributos_url
    click_on 'New Plano Verificar Atributo'

    fill_in 'Atributo', with: @plano_verificar_atributo.atributo
    fill_in 'Op', with: @plano_verificar_atributo.op
    fill_in 'Plano', with: @plano_verificar_atributo.plano_id
    fill_in 'Valor', with: @plano_verificar_atributo.valor
    click_on 'Create Plano verificar atributo'

    assert_text 'Plano verificar atributo was successfully created'
    click_on 'Back'
  end

  test 'updating a Plano verificar atributo' do
    visit plano_verificar_atributos_url
    click_on 'Edit', match: :first

    fill_in 'Atributo', with: @plano_verificar_atributo.atributo
    fill_in 'Op', with: @plano_verificar_atributo.op
    fill_in 'Plano', with: @plano_verificar_atributo.plano_id
    fill_in 'Valor', with: @plano_verificar_atributo.valor
    click_on 'Update Plano verificar atributo'

    assert_text 'Plano verificar atributo was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Plano verificar atributo' do
    visit plano_verificar_atributos_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Plano verificar atributo was successfully destroyed'
  end
end
