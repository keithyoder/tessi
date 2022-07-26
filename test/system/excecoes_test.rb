# frozen_string_literal: true

require 'application_system_test_case'

class ExcecoesTest < ApplicationSystemTestCase
  setup do
    @excecao = excecoes(:one)
  end

  test 'visiting the index' do
    visit excecoes_url
    assert_selector 'h1', text: 'Excecoes'
  end

  test 'creating a Excecao' do
    visit excecoes_url
    click_on 'New Excecao'

    fill_in 'Contrato', with: @excecao.contrato_id
    fill_in 'Tipo', with: @excecao.tipo
    fill_in 'Usuario', with: @excecao.usuario
    fill_in 'Valido ate', with: @excecao.valido_ate
    click_on 'Create Excecao'

    assert_text 'Excecao was successfully created'
    click_on 'Back'
  end

  test 'updating a Excecao' do
    visit excecoes_url
    click_on 'Edit', match: :first

    fill_in 'Contrato', with: @excecao.contrato_id
    fill_in 'Tipo', with: @excecao.tipo
    fill_in 'Usuario', with: @excecao.usuario
    fill_in 'Valido ate', with: @excecao.valido_ate
    click_on 'Update Excecao'

    assert_text 'Excecao was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Excecao' do
    visit excecoes_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Excecao was successfully destroyed'
  end
end
