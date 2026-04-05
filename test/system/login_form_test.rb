# frozen_string_literal: true

require 'application_system_test_case'

class LoginFormTest < ApplicationSystemTestCase
  test 'ログイン画面にログイン状態を保持するの文言が表示される' do
    visit new_user_session_path

    assert_text 'ログイン状態を保持する'
  end
end
