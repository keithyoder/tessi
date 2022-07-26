# frozen_string_literal: true

require 'application_system_test_case'

class FibraCaixasTest < ApplicationSystemTestCase
  setup do
    @fibra_caixa = fibra_caixas(:one)
  end

  test 'visiting the index' do
    visit fibra_caixas_url
    assert_selector 'h1', text: 'Fibra Caixas'
  end

  test 'creating a Fibra caixa' do
    visit fibra_caixas_url
    click_on 'New Fibra Caixa'

    fill_in 'Capacidade', with: @fibra_caixa.capacidade
    fill_in 'Fibra rede', with: @fibra_caixa.fibra_rede_id
    fill_in 'Nome', with: @fibra_caixa.nome
    click_on 'Create Fibra caixa'

    assert_text 'Fibra caixa was successfully created'
    click_on 'Back'
  end

  test 'updating a Fibra caixa' do
    visit fibra_caixas_url
    click_on 'Edit', match: :first

    fill_in 'Capacidade', with: @fibra_caixa.capacidade
    fill_in 'Fibra rede', with: @fibra_caixa.fibra_rede_id
    fill_in 'Nome', with: @fibra_caixa.nome
    click_on 'Update Fibra caixa'

    assert_text 'Fibra caixa was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Fibra caixa' do
    visit fibra_caixas_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Fibra caixa was successfully destroyed'
  end
end
