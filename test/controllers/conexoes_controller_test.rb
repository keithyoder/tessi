# frozen_string_literal: true

require 'test_helper'

class ConexoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conexao = conexoes(:one)
  end

  test 'should get index' do
    get conexoes_url
    assert_response :success
  end

  test 'should get new' do
    get new_conexao_url
    assert_response :success
  end

  test 'should create conexao' do
    assert_difference('Conexao.count') do
      post conexoes_url,
           params: { conexao: { auto_bloqueio: @conexao.auto_bloqueio, bloqueado: @conexao.bloqueado, ip: @conexao.ip,
                                pessoa_id: @conexao.pessoa_id, plano_id: @conexao.plano_id, ponto_id: @conexao.ponto_id, velocidade: @conexao.velocidade } }
    end

    assert_redirected_to conexao_url(Conexao.last)
  end

  test 'should show conexao' do
    get conexao_url(@conexao)
    assert_response :success
  end

  test 'should get edit' do
    get edit_conexao_url(@conexao)
    assert_response :success
  end

  test 'should update conexao' do
    patch conexao_url(@conexao),
          params: { conexao: { auto_bloqueio: @conexao.auto_bloqueio, bloqueado: @conexao.bloqueado, ip: @conexao.ip,
                               pessoa_id: @conexao.pessoa_id, plano_id: @conexao.plano_id, ponto_id: @conexao.ponto_id, velocidade: @conexao.velocidade } }
    assert_redirected_to conexao_url(@conexao)
  end

  test 'should destroy conexao' do
    assert_difference('Conexao.count', -1) do
      delete conexao_url(@conexao)
    end

    assert_redirected_to conexoes_url
  end
end
