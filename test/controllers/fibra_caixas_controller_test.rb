require 'test_helper'

class FibraCaixasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fibra_caixa = fibra_caixas(:one)
  end

  test "should get index" do
    get fibra_caixas_url
    assert_response :success
  end

  test "should get new" do
    get new_fibra_caixa_url
    assert_response :success
  end

  test "should create fibra_caixa" do
    assert_difference('FibraCaixa.count') do
      post fibra_caixas_url, params: { fibra_caixa: { capacidade: @fibra_caixa.capacidade, fibra_rede_id: @fibra_caixa.fibra_rede_id, nome: @fibra_caixa.nome } }
    end

    assert_redirected_to fibra_caixa_url(FibraCaixa.last)
  end

  test "should show fibra_caixa" do
    get fibra_caixa_url(@fibra_caixa)
    assert_response :success
  end

  test "should get edit" do
    get edit_fibra_caixa_url(@fibra_caixa)
    assert_response :success
  end

  test "should update fibra_caixa" do
    patch fibra_caixa_url(@fibra_caixa), params: { fibra_caixa: { capacidade: @fibra_caixa.capacidade, fibra_rede_id: @fibra_caixa.fibra_rede_id, nome: @fibra_caixa.nome } }
    assert_redirected_to fibra_caixa_url(@fibra_caixa)
  end

  test "should destroy fibra_caixa" do
    assert_difference('FibraCaixa.count', -1) do
      delete fibra_caixa_url(@fibra_caixa)
    end

    assert_redirected_to fibra_caixas_url
  end
end
