# frozen_string_literal: true

require 'test_helper'

class PagamentoPerfisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pagamento_perfil = pagamento_perfis(:one)
  end

  test 'should get index' do
    get pagamento_perfis_url
    assert_response :success
  end

  test 'should get new' do
    get new_pagamento_perfil_url
    assert_response :success
  end

  test 'should create pagamento_perfil' do
    assert_difference('PagamentoPerfil.count') do
      post pagamento_perfis_url,
           params: { pagamento_perfil: { agencia: @pagamento_perfil.agencia, carteira: @pagamento_perfil.carteira,
                                         cedente: @pagamento_perfil.cedente, conta: @pagamento_perfil.conta, nome: @pagamento_perfil.nome, tipo: @pagamento_perfil.tipo } }
    end

    assert_redirected_to pagamento_perfil_url(PagamentoPerfil.last)
  end

  test 'should show pagamento_perfil' do
    get pagamento_perfil_url(@pagamento_perfil)
    assert_response :success
  end

  test 'should get edit' do
    get edit_pagamento_perfil_url(@pagamento_perfil)
    assert_response :success
  end

  test 'should update pagamento_perfil' do
    patch pagamento_perfil_url(@pagamento_perfil),
          params: { pagamento_perfil: { agencia: @pagamento_perfil.agencia, carteira: @pagamento_perfil.carteira,
                                        cedente: @pagamento_perfil.cedente, conta: @pagamento_perfil.conta, nome: @pagamento_perfil.nome, tipo: @pagamento_perfil.tipo } }
    assert_redirected_to pagamento_perfil_url(@pagamento_perfil)
  end

  test 'should destroy pagamento_perfil' do
    assert_difference('PagamentoPerfil.count', -1) do
      delete pagamento_perfil_url(@pagamento_perfil)
    end

    assert_redirected_to pagamento_perfis_url
  end
end
