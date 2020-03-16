require 'test_helper'

class FibraRedesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fibra_rede = fibra_redes(:one)
  end

  test "should get index" do
    get fibra_redes_url
    assert_response :success
  end

  test "should get new" do
    get new_fibra_rede_url
    assert_response :success
  end

  test "should create fibra_rede" do
    assert_difference('FibraRede.count') do
      post fibra_redes_url, params: { fibra_rede: { nome: @fibra_rede.nome, ponto_id: @fibra_rede.ponto_id } }
    end

    assert_redirected_to fibra_rede_url(FibraRede.last)
  end

  test "should show fibra_rede" do
    get fibra_rede_url(@fibra_rede)
    assert_response :success
  end

  test "should get edit" do
    get edit_fibra_rede_url(@fibra_rede)
    assert_response :success
  end

  test "should update fibra_rede" do
    patch fibra_rede_url(@fibra_rede), params: { fibra_rede: { nome: @fibra_rede.nome, ponto_id: @fibra_rede.ponto_id } }
    assert_redirected_to fibra_rede_url(@fibra_rede)
  end

  test "should destroy fibra_rede" do
    assert_difference('FibraRede.count', -1) do
      delete fibra_rede_url(@fibra_rede)
    end

    assert_redirected_to fibra_redes_url
  end
end
