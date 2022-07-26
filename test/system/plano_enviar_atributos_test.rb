# frozen_string_literal: true

require 'application_system_test_case'

class PlanoEnviarAtributosTest < ApplicationSystemTestCase
  setup do
    @plano_enviar_atributo = plano_enviar_atributos(:one)
  end

  test 'visiting the index' do
    visit plano_enviar_atributos_url
    assert_selector 'h1', text: 'Plano Enviar Atributos'
  end

  test 'creating a Plano enviar atributo' do
    visit plano_enviar_atributos_url
    click_on 'New Plano Enviar Atributo'

    fill_in 'Atributo', with: @plano_enviar_atributo.atributo
    fill_in 'Op', with: @plano_enviar_atributo.op
    fill_in 'Plano', with: @plano_enviar_atributo.plano_id
    fill_in 'Valor', with: @plano_enviar_atributo.valor
    click_on 'Create Plano enviar atributo'

    assert_text 'Plano enviar atributo was successfully created'
    click_on 'Back'
  end

  test 'updating a Plano enviar atributo' do
    visit plano_enviar_atributos_url
    click_on 'Edit', match: :first

    fill_in 'Atributo', with: @plano_enviar_atributo.atributo
    fill_in 'Op', with: @plano_enviar_atributo.op
    fill_in 'Plano', with: @plano_enviar_atributo.plano_id
    fill_in 'Valor', with: @plano_enviar_atributo.valor
    click_on 'Update Plano enviar atributo'

    assert_text 'Plano enviar atributo was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Plano enviar atributo' do
    visit plano_enviar_atributos_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Plano enviar atributo was successfully destroyed'
  end
end
