# frozen_string_literal: true

require 'test_helper'

class Nf21ItensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nf21_item = nf21_itens(:one)
  end

  test 'should get index' do
    get nf21_itens_url
    assert_response :success
  end

  test 'should get new' do
    get new_nf21_item_url
    assert_response :success
  end

  test 'should create nf21_item' do
    assert_difference('Nf21Item.count') do
      post nf21_itens_url,
           params: { nf21_item: { item: @nf21_item.item, nf_21: @nf21_item.nf_21, references: @nf21_item.references,
                                  text: @nf21_item.text } }
    end

    assert_redirected_to nf21_item_url(Nf21Item.last)
  end

  test 'should show nf21_item' do
    get nf21_item_url(@nf21_item)
    assert_response :success
  end

  test 'should get edit' do
    get edit_nf21_item_url(@nf21_item)
    assert_response :success
  end

  test 'should update nf21_item' do
    patch nf21_item_url(@nf21_item),
          params: { nf21_item: { item: @nf21_item.item, nf_21: @nf21_item.nf_21, references: @nf21_item.references,
                                 text: @nf21_item.text } }
    assert_redirected_to nf21_item_url(@nf21_item)
  end

  test 'should destroy nf21_item' do
    assert_difference('Nf21Item.count', -1) do
      delete nf21_item_url(@nf21_item)
    end

    assert_redirected_to nf21_itens_url
  end
end
