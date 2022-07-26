# frozen_string_literal: true

require 'application_system_test_case'

class FaturasTest < ApplicationSystemTestCase
  setup do
    @fatura = faturas(:one)
  end

  test 'visiting the index' do
    visit faturas_url
    assert_selector 'h1', text: 'Faturas'
  end

  test 'creating a Fatura' do
    visit faturas_url
    click_on 'New Fatura'

    fill_in 'Arquivo remessa', with: @fatura.arquivo_remessa
    fill_in 'Contrato', with: @fatura.contrato_id
    fill_in 'Data cancelamento', with: @fatura.data_cancelamento
    fill_in 'Data remessa', with: @fatura.data_remessa
    fill_in 'Nossonumero', with: @fatura.nossonumero
    fill_in 'Parcela', with: @fatura.parcela
    fill_in 'Valor', with: @fatura.valor
    fill_in 'Vencimento', with: @fatura.vencimento
    click_on 'Create Fatura'

    assert_text 'Fatura was successfully created'
    click_on 'Back'
  end

  test 'updating a Fatura' do
    visit faturas_url
    click_on 'Edit', match: :first

    fill_in 'Arquivo remessa', with: @fatura.arquivo_remessa
    fill_in 'Contrato', with: @fatura.contrato_id
    fill_in 'Data cancelamento', with: @fatura.data_cancelamento
    fill_in 'Data remessa', with: @fatura.data_remessa
    fill_in 'Nossonumero', with: @fatura.nossonumero
    fill_in 'Parcela', with: @fatura.parcela
    fill_in 'Valor', with: @fatura.valor
    fill_in 'Vencimento', with: @fatura.vencimento
    click_on 'Update Fatura'

    assert_text 'Fatura was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Fatura' do
    visit faturas_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Fatura was successfully destroyed'
  end
end
