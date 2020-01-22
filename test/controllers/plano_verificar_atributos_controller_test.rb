require 'test_helper'

class PlanoVerificarAtributosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plano_verificar_atributo = plano_verificar_atributos(:one)
  end

  test "should get index" do
    get plano_verificar_atributos_url
    assert_response :success
  end

  test "should get new" do
    get new_plano_verificar_atributo_url
    assert_response :success
  end

  test "should create plano_verificar_atributo" do
    assert_difference('PlanoVerificarAtributo.count') do
      post plano_verificar_atributos_url, params: { plano_verificar_atributo: { atributo: @plano_verificar_atributo.atributo, op: @plano_verificar_atributo.op, plano_id: @plano_verificar_atributo.plano_id, valor: @plano_verificar_atributo.valor } }
    end

    assert_redirected_to plano_verificar_atributo_url(PlanoVerificarAtributo.last)
  end

  test "should show plano_verificar_atributo" do
    get plano_verificar_atributo_url(@plano_verificar_atributo)
    assert_response :success
  end

  test "should get edit" do
    get edit_plano_verificar_atributo_url(@plano_verificar_atributo)
    assert_response :success
  end

  test "should update plano_verificar_atributo" do
    patch plano_verificar_atributo_url(@plano_verificar_atributo), params: { plano_verificar_atributo: { atributo: @plano_verificar_atributo.atributo, op: @plano_verificar_atributo.op, plano_id: @plano_verificar_atributo.plano_id, valor: @plano_verificar_atributo.valor } }
    assert_redirected_to plano_verificar_atributo_url(@plano_verificar_atributo)
  end

  test "should destroy plano_verificar_atributo" do
    assert_difference('PlanoVerificarAtributo.count', -1) do
      delete plano_verificar_atributo_url(@plano_verificar_atributo)
    end

    assert_redirected_to plano_verificar_atributos_url
  end
end
