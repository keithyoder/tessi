# frozen_string_literal: true

require 'application_system_test_case'

class EquipamentosTest < ApplicationSystemTestCase
  setup do
    @equipamento = equipamentos(:one)
  end

  test 'visiting the index' do
    visit equipamentos_url
    assert_selector 'h1', text: 'Equipamentos'
  end

  test 'creating a Equipamento' do
    visit equipamentos_url
    click_on 'New Equipamento'

    fill_in 'Fabricante', with: @equipamento.fabricante
    fill_in 'Modelo', with: @equipamento.modelo
    fill_in 'Tipo', with: @equipamento.tipo
    click_on 'Create Equipamento'

    assert_text 'Equipamento was successfully created'
    click_on 'Back'
  end

  test 'updating a Equipamento' do
    visit equipamentos_url
    click_on 'Edit', match: :first

    fill_in 'Fabricante', with: @equipamento.fabricante
    fill_in 'Modelo', with: @equipamento.modelo
    fill_in 'Tipo', with: @equipamento.tipo
    click_on 'Update Equipamento'

    assert_text 'Equipamento was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Equipamento' do
    visit equipamentos_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Equipamento was successfully destroyed'
  end
end
