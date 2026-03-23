# frozen_string_literal: true

require 'test_helper'

class MemosDestroyTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @memo = memos(:one)
    @other_memo = memos(:two)
  end

  test '自分のメモを削除できる' do
    sign_in @user

    assert_difference('Memo.count', -1) do
      delete memo_url(@memo)
    end

    assert_redirected_to memos_url
  end

  test '子メモを持つ親メモを削除すると子メモも削除される' do
    sign_in @user

    @memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    assert_difference('Memo.count', -2) do
      delete memo_url(@memo)
    end

    assert_redirected_to memos_url
  end

  test '他人のメモは削除できない' do
    sign_in @user

    assert_no_difference('Memo.count') do
      delete memo_url(@other_memo)
    end

    assert_response :not_found
  end

  test '未ログイン時は削除できずログイン画面へリダイレクトされる' do
    assert_no_difference('Memo.count') do
      delete memo_url(@memo)
    end

    assert_redirected_to new_user_session_url
  end
end
