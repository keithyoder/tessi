require 'test_helper'

class WebhookEventosControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get webhook_eventos_new_url
    assert_response :success
  end

end
