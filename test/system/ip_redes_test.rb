# frozen_string_literal: true

require 'application_system_test_case'

class IpRedesTest < ApplicationSystemTestCase
  setup do
    @ip_rede = ip_redes(:one)
  end

  test 'visiting the index' do
    visit ip_redes_url
    assert_selector 'h1', text: 'Ip Redes'
  end

  test 'creating a Ip rede' do
    visit ip_redes_url
    click_on 'New Ip Rede'

    fill_in 'Rede', with: @ip_rede.rede
    click_on 'Create Ip rede'

    assert_text 'Ip rede was successfully created'
    click_on 'Back'
  end

  test 'updating a Ip rede' do
    visit ip_redes_url
    click_on 'Edit', match: :first

    fill_in 'Rede', with: @ip_rede.rede
    click_on 'Update Ip rede'

    assert_text 'Ip rede was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Ip rede' do
    visit ip_redes_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Ip rede was successfully destroyed'
  end
end
