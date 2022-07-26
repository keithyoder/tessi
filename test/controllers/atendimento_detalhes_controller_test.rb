# frozen_string_literal: true

require 'test_helper'

class AtendimentoDetalhesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @atendimento_detalhe = atendimento_detalhes(:one)
  end

  test 'should get index' do
    get atendimento_detalhes_url
    assert_response :success
  end

  test 'should get new' do
    get new_atendimento_detalhe_url
    assert_response :success
  end

  test 'should create atendimento_detalhe' do
    assert_difference('AtendimentoDetalhe.count') do
      post atendimento_detalhes_url,
           params: { atendimento_detalhe: { atendente_id: @atendimento_detalhe.atendente_id,
                                            atendimento_id: @atendimento_detalhe.atendimento_id, descricao: @atendimento_detalhe.descricao, tipo: @atendimento_detalhe.tipo } }
    end

    assert_redirected_to atendimento_detalhe_url(AtendimentoDetalhe.last)
  end

  test 'should show atendimento_detalhe' do
    get atendimento_detalhe_url(@atendimento_detalhe)
    assert_response :success
  end

  test 'should get edit' do
    get edit_atendimento_detalhe_url(@atendimento_detalhe)
    assert_response :success
  end

  test 'should update atendimento_detalhe' do
    patch atendimento_detalhe_url(@atendimento_detalhe),
          params: { atendimento_detalhe: { atendente_id: @atendimento_detalhe.atendente_id,
                                           atendimento_id: @atendimento_detalhe.atendimento_id, descricao: @atendimento_detalhe.descricao, tipo: @atendimento_detalhe.tipo } }
    assert_redirected_to atendimento_detalhe_url(@atendimento_detalhe)
  end

  test 'should destroy atendimento_detalhe' do
    assert_difference('AtendimentoDetalhe.count', -1) do
      delete atendimento_detalhe_url(@atendimento_detalhe)
    end

    assert_redirected_to atendimento_detalhes_url
  end
end
