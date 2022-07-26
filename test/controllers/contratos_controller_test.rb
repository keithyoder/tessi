# frozen_string_literal: true

require 'test_helper'

class ContratosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contrato = contratos(:one)
  end

  test 'should get index' do
    get contratos_url
    assert_response :success
  end

  test 'should get new' do
    get new_contrato_url
    assert_response :success
  end

  test 'should create contrato' do
    assert_difference('Contrato.count') do
      post contratos_url,
           params: { contrato: { adesao: @contrato.adesao, cancelamento: @contrato.cancelamento,
                                 dia_vencimento: @contrato.dia_vencimento, emite_nf: @contrato.emite_nf, numero_conexoes: @contrato.numero_conexoes, pessoa_id: @contrato.pessoa_id, plano_id: @contrato.plano_id, prazo_meses: @contrato.prazo_meses, primeiro_vencimento: @contrato.primeiro_vencimento, status: @contrato.status, valor_instalacao: @contrato.valor_instalacao } }
    end

    assert_redirected_to contrato_url(Contrato.last)
  end

  test 'should show contrato' do
    get contrato_url(@contrato)
    assert_response :success
  end

  test 'should get edit' do
    get edit_contrato_url(@contrato)
    assert_response :success
  end

  test 'should update contrato' do
    patch contrato_url(@contrato),
          params: { contrato: { adesao: @contrato.adesao, cancelamento: @contrato.cancelamento,
                                dia_vencimento: @contrato.dia_vencimento, emite_nf: @contrato.emite_nf, numero_conexoes: @contrato.numero_conexoes, pessoa_id: @contrato.pessoa_id, plano_id: @contrato.plano_id, prazo_meses: @contrato.prazo_meses, primeiro_vencimento: @contrato.primeiro_vencimento, status: @contrato.status, valor_instalacao: @contrato.valor_instalacao } }
    assert_redirected_to contrato_url(@contrato)
  end

  test 'should destroy contrato' do
    assert_difference('Contrato.count', -1) do
      delete contrato_url(@contrato)
    end

    assert_redirected_to contratos_url
  end
end
