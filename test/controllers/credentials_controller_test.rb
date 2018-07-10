require 'test_helper'

class CredentialsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get credentials_index_url
    assert_response :success
  end

  test 'should get update' do
    get credentials_update_url
    assert_response :success
  end
end
