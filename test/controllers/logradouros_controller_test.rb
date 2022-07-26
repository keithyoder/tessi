# frozen_string_literal: true

require 'test_helper'

class LogradourosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @logradouro = logradouros(:one)
  end

  test 'should get index' do
    get logradouros_url
    assert_response :success
  end

  test 'should get new' do
    get new_logradouro_url
    assert_response :success
  end

  test 'should create logradouro' do
    assert_difference('Logradouro.count') do
      post logradouros_url,
           params: { logradouro: { bairro_id: @logradouro.bairro_id, cep: @logradouro.cep, nome: @logradouro.nome } }
    end

    assert_redirected_to logradouro_url(Logradouro.last)
  end

  test 'should show logradouro' do
    get logradouro_url(@logradouro)
    assert_response :success
  end

  test 'should get edit' do
    get edit_logradouro_url(@logradouro)
    assert_response :success
  end

  test 'should update logradouro' do
    patch logradouro_url(@logradouro),
          params: { logradouro: { bairro_id: @logradouro.bairro_id, cep: @logradouro.cep, nome: @logradouro.nome } }
    assert_redirected_to logradouro_url(@logradouro)
  end

  test 'should destroy logradouro' do
    assert_difference('Logradouro.count', -1) do
      delete logradouro_url(@logradouro)
    end

    assert_redirected_to logradouros_url
  end
end
