# frozen_string_literal: true

require 'test_helper'

class ClassificacoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @classificacao = classificacoes(:one)
  end

  test 'should get index' do
    get classificacoes_url
    assert_response :success
  end

  test 'should get new' do
    get new_classificacao_url
    assert_response :success
  end

  test 'should create classificacao' do
    assert_difference('Classificacao.count') do
      post classificacoes_url, params: { classificacao: { nome: @classificacao.nome, tipo: @classificacao.tipo } }
    end

    assert_redirected_to classificacao_url(Classificacao.last)
  end

  test 'should show classificacao' do
    get classificacao_url(@classificacao)
    assert_response :success
  end

  test 'should get edit' do
    get edit_classificacao_url(@classificacao)
    assert_response :success
  end

  test 'should update classificacao' do
    patch classificacao_url(@classificacao),
          params: { classificacao: { nome: @classificacao.nome, tipo: @classificacao.tipo } }
    assert_redirected_to classificacao_url(@classificacao)
  end

  test 'should destroy classificacao' do
    assert_difference('Classificacao.count', -1) do
      delete classificacao_url(@classificacao)
    end

    assert_redirected_to classificacoes_url
  end
end
