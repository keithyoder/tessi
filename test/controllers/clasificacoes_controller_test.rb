require 'test_helper'

class ClasificacoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clasificacao = clasificacoes(:one)
  end

  test "should get index" do
    get clasificacoes_url
    assert_response :success
  end

  test "should get new" do
    get new_clasificacao_url
    assert_response :success
  end

  test "should create clasificacao" do
    assert_difference('Clasificacao.count') do
      post clasificacoes_url, params: { clasificacao: { nome: @clasificacao.nome, tipo: @clasificacao.tipo } }
    end

    assert_redirected_to clasificacao_url(Clasificacao.last)
  end

  test "should show clasificacao" do
    get clasificacao_url(@clasificacao)
    assert_response :success
  end

  test "should get edit" do
    get edit_clasificacao_url(@clasificacao)
    assert_response :success
  end

  test "should update clasificacao" do
    patch clasificacao_url(@clasificacao), params: { clasificacao: { nome: @clasificacao.nome, tipo: @clasificacao.tipo } }
    assert_redirected_to clasificacao_url(@clasificacao)
  end

  test "should destroy clasificacao" do
    assert_difference('Clasificacao.count', -1) do
      delete clasificacao_url(@clasificacao)
    end

    assert_redirected_to clasificacoes_url
  end
end
