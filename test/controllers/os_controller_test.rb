# frozen_string_literal: true

require 'test_helper'

class OsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @os = os(:one)
  end

  test 'should get index' do
    get os_index_url
    assert_response :success
  end

  test 'should get new' do
    get new_os_url
    assert_response :success
  end

  test 'should create os' do
    assert_difference('Os.count') do
      post os_index_url,
           params: { os: { aberto_por_id: @os.aberto_por_id, classificao_id: @os.classificao_id, conexao_id: @os.conexao_id,
                           descricao: @os.descricao, encerramento: @os.encerramento, fechamento: @os.fechamento, pessoa_id: @os.pessoa_id, responsavel_id: @os.responsavel_id, tecnico_1_id: @os.tecnico_1_id, tecnico_2_id: @os.tecnico_2_id, tipo: @os.tipo } }
    end

    assert_redirected_to os_url(Os.last)
  end

  test 'should show os' do
    get os_url(@os)
    assert_response :success
  end

  test 'should get edit' do
    get edit_os_url(@os)
    assert_response :success
  end

  test 'should update os' do
    patch os_url(@os),
          params: { os: { aberto_por_id: @os.aberto_por_id, classificao_id: @os.classificao_id, conexao_id: @os.conexao_id,
                          descricao: @os.descricao, encerramento: @os.encerramento, fechamento: @os.fechamento, pessoa_id: @os.pessoa_id, responsavel_id: @os.responsavel_id, tecnico_1_id: @os.tecnico_1_id, tecnico_2_id: @os.tecnico_2_id, tipo: @os.tipo } }
    assert_redirected_to os_url(@os)
  end

  test 'should destroy os' do
    assert_difference('Os.count', -1) do
      delete os_url(@os)
    end

    assert_redirected_to os_index_url
  end
end
