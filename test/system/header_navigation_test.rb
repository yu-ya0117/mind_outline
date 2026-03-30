# frozen_string_literal: true

require 'application_system_test_case'

class HeaderNavigationTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  setup do
    @user = users(:one)
    @memo = memos(:one)
    login_as(@user, scope: :user)
  end

  teardown do
    Warden.test_reset!
  end

  test 'タイトルクリックでホームへ戻れる' do
    visit memo_path(@memo)

    click_on 'MindOutline'

    assert_current_path memos_path
    assert_text 'ホーム'
  end

  test 'ヘッダーからログアウトできる' do
    visit memos_path

    click_on 'ログアウト'

    assert_current_path root_path
    assert_text 'ログイン'
  end
end
