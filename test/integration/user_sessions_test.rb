# frozen_string_literal: true

require 'test_helper'

class UserSessionsTest < ActionDispatch::IntegrationTest
  test 'ログイン画面が表示される' do
    get new_user_session_path
    assert_response :success

    assert_select 'h2', text: 'ログイン'
    assert_select "input[name='user[email]']"
    assert_select "input[name='user[password]']"
    assert_select "input[type='submit'][value='ログイン']"
    assert_select 'a', text: '初めて利用する方はこちら'
  end

  test 'remember me が表示される' do
    get new_user_session_path
    assert_response :success

    assert_select "input[name='user[remember_me]'][type='checkbox']"
    assert_select 'label', text: '次回から自動的にログインする'
  end
end
