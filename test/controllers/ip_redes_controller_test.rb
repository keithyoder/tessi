require 'test_helper'

class IpRedesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ip_rede = ip_redes(:one)
  end

  test "should get index" do
    get ip_redes_url
    assert_response :success
  end

  test "should get new" do
    get new_ip_rede_url
    assert_response :success
  end

  test "should create ip_rede" do
    assert_difference('IpRede.count') do
      post ip_redes_url, params: { ip_rede: { rede: @ip_rede.rede } }
    end

    assert_redirected_to ip_rede_url(IpRede.last)
  end

  test "should show ip_rede" do
    get ip_rede_url(@ip_rede)
    assert_response :success
  end

  test "should get edit" do
    get edit_ip_rede_url(@ip_rede)
    assert_response :success
  end

  test "should update ip_rede" do
    patch ip_rede_url(@ip_rede), params: { ip_rede: { rede: @ip_rede.rede } }
    assert_redirected_to ip_rede_url(@ip_rede)
  end

  test "should destroy ip_rede" do
    assert_difference('IpRede.count', -1) do
      delete ip_rede_url(@ip_rede)
    end

    assert_redirected_to ip_redes_url
  end
end
