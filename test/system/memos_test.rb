# frozen_string_literal: true

require 'application_system_test_case'

class MemosTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @memo = memos(:one)
  end

  test '一覧画面から詳細画面へ遷移できる' do
    sign_in @user
    visit memos_path

    click_on '詳細', match: :first

    assert_current_path memo_path(@memo)
    assert_text 'メモ詳細'
    assert_text @memo.title
    assert_text @memo.content
  end
end
