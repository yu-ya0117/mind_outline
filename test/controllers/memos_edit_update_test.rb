# frozen_string_literal: true

require 'test_helper'

class MemosEditUpdateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @memo = memos(:one)
    @other_memo = memos(:two)
  end

  test '自分のメモ編集画面を表示できる' do
    sign_in @user

    get edit_memo_url(@memo)
    assert_response :success
    assert_select 'h2', text: 'メモ編集'
    assert_match @memo.title, response.body
    assert_match @memo.content, response.body
  end

  test '自分のメモを更新できる' do
    sign_in @user

    patch memo_url(@memo), params: {
      memo: {
        title: '更新後タイトル',
        content: '更新後内容'
      }
    }

    assert_redirected_to memo_url(@memo)

    @memo.reload
    assert_equal '更新後タイトル', @memo.title
    assert_equal '更新後内容', @memo.content
  end

  test 'メモ更新に失敗した時、編集画面が再表示される' do
    sign_in @user

    patch memo_url(@memo), params: {
      memo: {
        title: '',
        content: ''
      }
    }

    assert_response :unprocessable_entity
    assert_select 'h2', text: 'メモ編集'

    @memo.reload
    assert_not_equal '', @memo.title
  end

  test '他人のメモ編集画面にはアクセスできない' do
    sign_in @user

    get edit_memo_url(@other_memo)
    assert_response :not_found
  end

  test '他人のメモは更新できない' do
    sign_in @user

    patch memo_url(@other_memo), params: {
      memo: {
        title: '不正更新',
        content: '不正更新'
      }
    }

    assert_response :not_found

    @other_memo.reload
    assert_not_equal '不正更新', @other_memo.title
  end

  test '未ログイン時は編集画面にアクセスできずログイン画面へリダイレクトされる' do
    get edit_memo_url(@memo)
    assert_redirected_to new_user_session_url
  end

  test '未ログイン時は更新できずログイン画面へリダイレクトされる' do
    patch memo_url(@memo), params: {
      memo: {
        title: '更新後タイトル',
        content: '更新後内容'
      }
    }

    assert_redirected_to new_user_session_url
  end

  test 'メモ編集画面に子メモが表示される' do
    sign_in @user

    child_memo = @memo.children.create!(
      user: @user,
      title: '子メモタイトル',
      content: '子メモ内容'
    )

    get edit_memo_url(@memo)
    assert_response :success
    assert_match child_memo.title, response.body
    assert_match child_memo.content, response.body
  end
end
