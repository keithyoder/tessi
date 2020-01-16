require 'test_helper'

class ServidoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @servidor = servidores(:one)
  end

  test "should get index" do
    get servidores_url
    assert_response :success
  end

  test "should get new" do
    get new_servidor_url
    assert_response :success
  end

  test "should create servidor" do
    assert_difference('Servidor.count') do
      post servidores_url, params: { servidor: { api_porta: @servidor.api_porta, ip: @servidor.ip, nome: @servidor.nome, senha: @servidor.senha, snmp_comunidade: @servidor.snmp_comunidade, snmp_porta: @servidor.snmp_porta, ssh_porta: @servidor.ssh_porta, usuario: @servidor.usuario } }
    end

    assert_redirected_to servidor_url(Servidor.last)
  end

  test "should show servidor" do
    get servidor_url(@servidor)
    assert_response :success
  end

  test "should get edit" do
    get edit_servidor_url(@servidor)
    assert_response :success
  end

  test "should update servidor" do
    patch servidor_url(@servidor), params: { servidor: { api_porta: @servidor.api_porta, ip: @servidor.ip, nome: @servidor.nome, senha: @servidor.senha, snmp_comunidade: @servidor.snmp_comunidade, snmp_porta: @servidor.snmp_porta, ssh_porta: @servidor.ssh_porta, usuario: @servidor.usuario } }
    assert_redirected_to servidor_url(@servidor)
  end

  test "should destroy servidor" do
    assert_difference('Servidor.count', -1) do
      delete servidor_url(@servidor)
    end

    assert_redirected_to servidores_url
  end
end
