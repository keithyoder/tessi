# frozen_string_literal: true

require 'test_helper'

class ExcecoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @excecao = excecoes(:one)
  end

  test 'should get index' do
    get excecoes_url
    assert_response :success
  end

  test 'should get new' do
    get new_excecao_url
    assert_response :success
  end

  test 'should create excecao' do
    assert_difference('Excecao.count') do
      post excecoes_url,
           params: { excecao: { contrato_id: @excecao.contrato_id, tipo: @excecao.tipo, usuario: @excecao.usuario,
                                valido_ate: @excecao.valido_ate } }
    end

    assert_redirected_to excecao_url(Excecao.last)
  end

  test 'should show excecao' do
    get excecao_url(@excecao)
    assert_response :success
  end

  test 'should get edit' do
    get edit_excecao_url(@excecao)
    assert_response :success
  end

  test 'should update excecao' do
    patch excecao_url(@excecao),
          params: { excecao: { contrato_id: @excecao.contrato_id, tipo: @excecao.tipo, usuario: @excecao.usuario,
                               valido_ate: @excecao.valido_ate } }
    assert_redirected_to excecao_url(@excecao)
  end

  test 'should destroy excecao' do
    assert_difference('Excecao.count', -1) do
      delete excecao_url(@excecao)
    end

    assert_redirected_to excecoes_url
  end
end
