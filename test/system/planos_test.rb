# frozen_string_literal: true

require 'application_system_test_case'

class PlanosTest < ApplicationSystemTestCase
  setup do
    @plano = planos(:one)
  end

  test 'visiting the index' do
    visit planos_url
    assert_selector 'h1', text: 'Planos'
  end

  test 'creating a Plano' do
    visit planos_url
    click_on 'New Plano'

    check 'Burst' if @plano.burst
    fill_in 'Download', with: @plano.download
    fill_in 'Mensalidade', with: @plano.mensalidade
    fill_in 'Nome', with: @plano.nome
    fill_in 'Upload', with: @plano.upload
    click_on 'Create Plano'

    assert_text 'Plano was successfully created'
    click_on 'Back'
  end

  test 'updating a Plano' do
    visit planos_url
    click_on 'Edit', match: :first

    check 'Burst' if @plano.burst
    fill_in 'Download', with: @plano.download
    fill_in 'Mensalidade', with: @plano.mensalidade
    fill_in 'Nome', with: @plano.nome
    fill_in 'Upload', with: @plano.upload
    click_on 'Update Plano'

    assert_text 'Plano was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Plano' do
    visit planos_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Plano was successfully destroyed'
  end
end
