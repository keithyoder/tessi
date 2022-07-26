# frozen_string_literal: true

require 'application_system_test_case'

class Nf21ItensTest < ApplicationSystemTestCase
  setup do
    @nf21_item = nf21_itens(:one)
  end

  test 'visiting the index' do
    visit nf21_itens_url
    assert_selector 'h1', text: 'Nf21 Itens'
  end

  test 'creating a Nf21 item' do
    visit nf21_itens_url
    click_on 'New Nf21 Item'

    fill_in 'Item', with: @nf21_item.item
    fill_in 'Nf 21', with: @nf21_item.nf_21
    fill_in 'References', with: @nf21_item.references
    fill_in 'Text', with: @nf21_item.text
    click_on 'Create Nf21 item'

    assert_text 'Nf21 item was successfully created'
    click_on 'Back'
  end

  test 'updating a Nf21 item' do
    visit nf21_itens_url
    click_on 'Edit', match: :first

    fill_in 'Item', with: @nf21_item.item
    fill_in 'Nf 21', with: @nf21_item.nf_21
    fill_in 'References', with: @nf21_item.references
    fill_in 'Text', with: @nf21_item.text
    click_on 'Update Nf21 item'

    assert_text 'Nf21 item was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Nf21 item' do
    visit nf21_itens_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Nf21 item was successfully destroyed'
  end
end
