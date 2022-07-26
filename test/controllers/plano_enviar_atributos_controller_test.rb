# frozen_string_literal: true

require 'test_helper'

class PlanoEnviarAtributosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plano_enviar_atributo = plano_enviar_atributos(:one)
  end

  test 'should get index' do
    get plano_enviar_atributos_url
    assert_response :success
  end

  test 'should get new' do
    get new_plano_enviar_atributo_url
    assert_response :success
  end

  test 'should create plano_enviar_atributo' do
    assert_difference('PlanoEnviarAtributo.count') do
      post plano_enviar_atributos_url,
           params: { plano_enviar_atributo: { atributo: @plano_enviar_atributo.atributo, op: @plano_enviar_atributo.op,
                                              plano_id: @plano_enviar_atributo.plano_id, valor: @plano_enviar_atributo.valor } }
    end

    assert_redirected_to plano_enviar_atributo_url(PlanoEnviarAtributo.last)
  end

  test 'should show plano_enviar_atributo' do
    get plano_enviar_atributo_url(@plano_enviar_atributo)
    assert_response :success
  end

  test 'should get edit' do
    get edit_plano_enviar_atributo_url(@plano_enviar_atributo)
    assert_response :success
  end

  test 'should update plano_enviar_atributo' do
    patch plano_enviar_atributo_url(@plano_enviar_atributo),
          params: { plano_enviar_atributo: { atributo: @plano_enviar_atributo.atributo, op: @plano_enviar_atributo.op,
                                             plano_id: @plano_enviar_atributo.plano_id, valor: @plano_enviar_atributo.valor } }
    assert_redirected_to plano_enviar_atributo_url(@plano_enviar_atributo)
  end

  test 'should destroy plano_enviar_atributo' do
    assert_difference('PlanoEnviarAtributo.count', -1) do
      delete plano_enviar_atributo_url(@plano_enviar_atributo)
    end

    assert_redirected_to plano_enviar_atributos_url
  end
end
