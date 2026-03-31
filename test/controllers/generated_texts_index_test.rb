# frozen_string_literal: true

require 'test_helper'

class GeneratedTextsIndexTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @memo = memos(:one)
  end

  test '全保存履歴を表示できる' do
    get generated_texts_path
    assert_response :success
    assert_match '生成結果保存履歴', response.body
  end

  test 'メモごとの生成結果保存履歴を表示できる' do
    get memo_generated_texts_path(@memo)
    assert_response :success
    assert_match '生成結果保存履歴', response.body
  end

  test '全保存履歴ではホームへ戻るリンクのみ表示される' do
    get generated_texts_path
    assert_response :success
    assert_match 'メモ一覧へ戻る', response.body
    refute_match 'メモ詳細へ戻る', response.body
  end

  test 'メモごとの保存履歴ではメモ詳細へ戻るとホームへ戻るが表示される' do
    get memo_generated_texts_path(@memo)
    assert_response :success
    assert_match 'メモ詳細へ戻る', response.body
    assert_match 'メモ一覧へ戻る', response.body
  end
end
