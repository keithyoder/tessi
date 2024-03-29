# frozen_string_literal: true

require 'application_system_test_case'

class EstadosTest < ApplicationSystemTestCase
  setup do
    @estado = estados(:one)
  end

  test 'visiting the index' do
    visit estados_url
    assert_selector 'h1', text: 'Estados'
  end

  test 'creating a Estado' do
    visit estados_url
    click_on 'New Estado'

    fill_in 'Ibge', with: @estado.ibge
    fill_in 'Nome', with: @estado.nome
    fill_in 'Sigla', with: @estado.sigla
    click_on 'Create Estado'

    assert_text 'Estado was successfully created'
    click_on 'Back'
  end

  test 'updating a Estado' do
    visit estados_url
    click_on 'Edit', match: :first

    fill_in 'Ibge', with: @estado.ibge
    fill_in 'Nome', with: @estado.nome
    fill_in 'Sigla', with: @estado.sigla
    click_on 'Update Estado'

    assert_text 'Estado was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Estado' do
    visit estados_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Estado was successfully destroyed'
  end
end
