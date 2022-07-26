# frozen_string_literal: true

require 'test_helper'

class AtendimentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @atendimento = atendimentos(:one)
  end

  test 'should get index' do
    get atendimentos_url
    assert_response :success
  end

  test 'should get new' do
    get new_atendimento_url
    assert_response :success
  end

  test 'should create atendimento' do
    assert_difference('Atendimento.count') do
      post atendimentos_url,
           params: { atendimento: { classificaco_id: @atendimento.classificaco_id, conexao_id: @atendimento.conexao_id,
                                    contrato_id: @atendimento.contrato_id, fatura_id: @atendimento.fatura_id, fechamento: @atendimento.fechamento, pessoa_id: @atendimento.pessoa_id, responsavel_id: @atendimento.responsavel_id } }
    end

    assert_redirected_to atendimento_url(Atendimento.last)
  end

  test 'should show atendimento' do
    get atendimento_url(@atendimento)
    assert_response :success
  end

  test 'should get edit' do
    get edit_atendimento_url(@atendimento)
    assert_response :success
  end

  test 'should update atendimento' do
    patch atendimento_url(@atendimento),
          params: { atendimento: { classificaco_id: @atendimento.classificaco_id, conexao_id: @atendimento.conexao_id,
                                   contrato_id: @atendimento.contrato_id, fatura_id: @atendimento.fatura_id, fechamento: @atendimento.fechamento, pessoa_id: @atendimento.pessoa_id, responsavel_id: @atendimento.responsavel_id } }
    assert_redirected_to atendimento_url(@atendimento)
  end

  test 'should destroy atendimento' do
    assert_difference('Atendimento.count', -1) do
      delete atendimento_url(@atendimento)
    end

    assert_redirected_to atendimentos_url
  end
end
