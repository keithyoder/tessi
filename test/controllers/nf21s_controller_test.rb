require 'test_helper'

class Nf21sControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nf21 = nf21s(:one)
  end

  test "should get index" do
    get nf21s_url
    assert_response :success
  end

  test "should get new" do
    get new_nf21_url
    assert_response :success
  end

  test "should create nf21" do
    assert_difference('Nf21.count') do
      post nf21s_url, params: { nf21: { cadastro: @nf21.cadastro, date,: @nf21.date,, decimal,: @nf21.decimal,, emissao: @nf21.emissao, integer,: @nf21.integer,, mestre: @nf21.mestre, numero: @nf21.numero, text: @nf21.text, text,: @nf21.text,, valor: @nf21.valor } }
    end

    assert_redirected_to nf21_url(Nf21.last)
  end

  test "should show nf21" do
    get nf21_url(@nf21)
    assert_response :success
  end

  test "should get edit" do
    get edit_nf21_url(@nf21)
    assert_response :success
  end

  test "should update nf21" do
    patch nf21_url(@nf21), params: { nf21: { cadastro: @nf21.cadastro, date,: @nf21.date,, decimal,: @nf21.decimal,, emissao: @nf21.emissao, integer,: @nf21.integer,, mestre: @nf21.mestre, numero: @nf21.numero, text: @nf21.text, text,: @nf21.text,, valor: @nf21.valor } }
    assert_redirected_to nf21_url(@nf21)
  end

  test "should destroy nf21" do
    assert_difference('Nf21.count', -1) do
      delete nf21_url(@nf21)
    end

    assert_redirected_to nf21s_url
  end
end
