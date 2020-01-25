require 'test_helper'

class ConexaoEnviarAtributosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conexao_enviar_atributo = conexao_enviar_atributos(:one)
  end

  test "should get index" do
    get conexao_enviar_atributos_url
    assert_response :success
  end

  test "should get new" do
    get new_conexao_enviar_atributo_url
    assert_response :success
  end

  test "should create conexao_enviar_atributo" do
    assert_difference('ConexaoEnviarAtributo.count') do
      post conexao_enviar_atributos_url, params: { conexao_enviar_atributo: { atributo: @conexao_enviar_atributo.atributo, conexao_id: @conexao_enviar_atributo.conexao_id, op: @conexao_enviar_atributo.op, valor: @conexao_enviar_atributo.valor } }
    end

    assert_redirected_to conexao_enviar_atributo_url(ConexaoEnviarAtributo.last)
  end

  test "should show conexao_enviar_atributo" do
    get conexao_enviar_atributo_url(@conexao_enviar_atributo)
    assert_response :success
  end

  test "should get edit" do
    get edit_conexao_enviar_atributo_url(@conexao_enviar_atributo)
    assert_response :success
  end

  test "should update conexao_enviar_atributo" do
    patch conexao_enviar_atributo_url(@conexao_enviar_atributo), params: { conexao_enviar_atributo: { atributo: @conexao_enviar_atributo.atributo, conexao_id: @conexao_enviar_atributo.conexao_id, op: @conexao_enviar_atributo.op, valor: @conexao_enviar_atributo.valor } }
    assert_redirected_to conexao_enviar_atributo_url(@conexao_enviar_atributo)
  end

  test "should destroy conexao_enviar_atributo" do
    assert_difference('ConexaoEnviarAtributo.count', -1) do
      delete conexao_enviar_atributo_url(@conexao_enviar_atributo)
    end

    assert_redirected_to conexao_enviar_atributos_url
  end
end
