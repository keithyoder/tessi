require 'test_helper'

class SacControllerTest < ActionDispatch::IntegrationTest
  test "should get inadimplencia" do
    get sac_inadimplencia_url
    assert_response :success
  end

end
