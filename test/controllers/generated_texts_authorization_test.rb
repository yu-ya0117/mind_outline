# frozen_string_literal: true

require 'test_helper'

class GeneratedTextsAuthorizationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test '他人のメモに紐づく生成結果保存履歴一覧にはアクセスできない' do
    other_memo = memos(:two)

    get memo_generated_texts_path(other_memo)
    assert_response :not_found
  end

  test '他人の生成結果詳細にはアクセスできない' do
    other_generated_text = generated_texts(:two)

    get memo_generated_text_path(other_generated_text.memo, other_generated_text)
    assert_response :not_found
  end

  test '未ログイン時は全保存履歴にアクセスできない' do
    sign_out @user
    get generated_texts_path
    assert_response :redirect
  end
end
