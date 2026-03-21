# frozen_string_literal: true

require 'test_helper'

class MemosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test '未ログインではホーム画面にアクセスできない' do
    get memos_path
    assert_redirected_to new_user_session_path
  end

  test 'ログイン済みならホーム画面にアクセスできる' do
    sign_in @user

    get memos_path
    assert_response :success
    assert_select 'h2', text: 'ホーム'
  end

  test 'ログイン済みなら新規メモ作成画面にアクセスできる' do
    sign_in @user

    get new_memo_path
    assert_response :success
    assert_select 'h2', text: '新規メモ作成'
    assert_select "input[name='memo[title]']"
    assert_select "textarea[name='memo[content]']"
    assert_select "input[type='submit']"
  end

  test 'ログイン済みなら新規メモを作成できる' do
    sign_in @user

    assert_difference('Memo.count', 1) do
      post memos_path, params: {
        memo: {
          title: 'テストメモ',
          content: 'テスト内容'
        }
      }
    end

    assert_redirected_to memos_path
    follow_redirect!
    assert_response :success
    assert_match 'テストメモ', response.body
  end

  test 'タイトル未入力では新規メモを作成できない' do
    sign_in @user

    assert_no_difference('Memo.count') do
      post memos_path, params: {
        memo: {
          title: '',
          content: 'テスト内容'
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
