# frozen_string_literal: true

require 'application_system_test_case'

class ContratosTest < ApplicationSystemTestCase
  setup do
    @contrato = contratos(:one)
  end

  test 'visiting the index' do
    visit contratos_url
    assert_selector 'h1', text: 'Contratos'
  end

  test 'creating a Contrato' do
    visit contratos_url
    click_on 'New Contrato'

    fill_in 'Adesao', with: @contrato.adesao
    fill_in 'Cancelamento', with: @contrato.cancelamento
    fill_in 'Dia vencimento', with: @contrato.dia_vencimento
    check 'Emite nf' if @contrato.emite_nf
    fill_in 'Numero conexoes', with: @contrato.numero_conexoes
    fill_in 'Pessoa', with: @contrato.pessoa_id
    fill_in 'Plano', with: @contrato.plano_id
    fill_in 'Prazo meses', with: @contrato.prazo_meses
    fill_in 'Primeiro vencimento', with: @contrato.primeiro_vencimento
    fill_in 'Status', with: @contrato.status
    fill_in 'Valor instalacao', with: @contrato.valor_instalacao
    click_on 'Create Contrato'

    assert_text 'Contrato was successfully created'
    click_on 'Back'
  end

  test 'updating a Contrato' do
    visit contratos_url
    click_on 'Edit', match: :first

    fill_in 'Adesao', with: @contrato.adesao
    fill_in 'Cancelamento', with: @contrato.cancelamento
    fill_in 'Dia vencimento', with: @contrato.dia_vencimento
    check 'Emite nf' if @contrato.emite_nf
    fill_in 'Numero conexoes', with: @contrato.numero_conexoes
    fill_in 'Pessoa', with: @contrato.pessoa_id
    fill_in 'Plano', with: @contrato.plano_id
    fill_in 'Prazo meses', with: @contrato.prazo_meses
    fill_in 'Primeiro vencimento', with: @contrato.primeiro_vencimento
    fill_in 'Status', with: @contrato.status
    fill_in 'Valor instalacao', with: @contrato.valor_instalacao
    click_on 'Update Contrato'

    assert_text 'Contrato was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Contrato' do
    visit contratos_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Contrato was successfully destroyed'
  end
end
