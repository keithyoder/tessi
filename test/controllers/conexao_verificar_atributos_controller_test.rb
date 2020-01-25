require 'test_helper'

class ConexaoVerificarAtributosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conexao_verificar_atributo = conexao_verificar_atributos(:one)
  end

  test "should get index" do
    get conexao_verificar_atributos_url
    assert_response :success
  end

  test "should get new" do
    get new_conexao_verificar_atributo_url
    assert_response :success
  end

  test "should create conexao_verificar_atributo" do
    assert_difference('ConexaoVerificarAtributo.count') do
      post conexao_verificar_atributos_url, params: { conexao_verificar_atributo: { atributo: @conexao_verificar_atributo.atributo, conexao_id: @conexao_verificar_atributo.conexao_id, op: @conexao_verificar_atributo.op, valor: @conexao_verificar_atributo.valor } }
    end

    assert_redirected_to conexao_verificar_atributo_url(ConexaoVerificarAtributo.last)
  end

  test "should show conexao_verificar_atributo" do
    get conexao_verificar_atributo_url(@conexao_verificar_atributo)
    assert_response :success
  end

  test "should get edit" do
    get edit_conexao_verificar_atributo_url(@conexao_verificar_atributo)
    assert_response :success
  end

  test "should update conexao_verificar_atributo" do
    patch conexao_verificar_atributo_url(@conexao_verificar_atributo), params: { conexao_verificar_atributo: { atributo: @conexao_verificar_atributo.atributo, conexao_id: @conexao_verificar_atributo.conexao_id, op: @conexao_verificar_atributo.op, valor: @conexao_verificar_atributo.valor } }
    assert_redirected_to conexao_verificar_atributo_url(@conexao_verificar_atributo)
  end

  test "should destroy conexao_verificar_atributo" do
    assert_difference('ConexaoVerificarAtributo.count', -1) do
      delete conexao_verificar_atributo_url(@conexao_verificar_atributo)
    end

    assert_redirected_to conexao_verificar_atributos_url
  end
end
