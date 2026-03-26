# frozen_string_literal: true

require 'test_helper'

class MemosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @memo = memos(:one)
    @other_memo = memos(:two)
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

  test '自分のメモ詳細画面を表示できる' do
    sign_in @user

    get memo_url(@memo)
    assert_response :success
    assert_select 'h2', text: 'メモ詳細'
    assert_match @memo.title, response.body
    assert_match @memo.content, response.body
  end

  test '他人のメモ詳細画面にはアクセスできない' do
    sign_in @user

    get memo_url(@other_memo)
    assert_response :not_found
  end

  test 'メモ一覧画面に詳細リンクが表示される' do
    sign_in @user

    get memos_url
    assert_response :success
    assert_select "a[href='#{memo_path(@memo)}']", text: '詳細'
  end

  test '未ログイン時はメモ詳細画面にアクセスできずログイン画面へリダイレクトされる' do
    get memo_url(@memo)
    assert_redirected_to new_user_session_url
  end

  test 'メモ詳細画面に子メモが表示される' do
    sign_in @user

    child_memo = @memo.children.create!(
      user: @user,
      title: '子メモタイトル',
      content: '子メモ内容'
    )

    get memo_url(@memo)
    assert_response :success
    assert_match child_memo.title, response.body
    assert_match child_memo.content, response.body
  end

  # test 'ai_generate は organize のとき ai_tree_source_text を使う' do
  #   sign_in @user

  #   expected_content = @memo.ai_tree_source_text
  #   received_args = nil

  #   fake_service = Object.new
  #   fake_service.define_singleton_method(:generate) do |**kwargs|
  #     received_args = kwargs
  #     '- 整理結果'
  #   end

  #   AiTextService.method(:new)

  #   AiTextService.define_singleton_method(:new) do
  #     fake_service
  #   end

  #   post ai_generate_memo_path(@memo), params: { tab: 'organize' }
  #   assert_response :success

  #   assert_equal(
  #     {
  #       tab: 'organize',
  #       content: expected_content,
  #       format: nil,
  #       tone: nil
  #     },
  #     received_args
  #   )
  # end

  # test 'ai_generate は summary のとき ai_source_text を使う' do
  #   sign_in @user

  #   expected_content = @memo.ai_source_text
  #   received_args = nil

  #   fake_service = Object.new
  #   fake_service.define_singleton_method(:generate) do |**kwargs|
  #     received_args = kwargs
  #     '要約結果'
  #   end

  #   AiTextService.method(:new)

  #   AiTextService.define_singleton_method(:new) do
  #     fake_service
  #   end

  #   post ai_generate_memo_path(@memo), params: { tab: 'summary' }
  #   assert_response :success

  #   assert_equal(
  #     {
  #       tab: 'summary',
  #       content: expected_content,
  #       format: nil,
  #       tone: nil
  #     },
  #     received_args
  #   )
  # end

  # test 'ai_generate は writing のとき format と tone を渡す' do
  #   sign_in @user

  #   expected_content = @memo.ai_source_text
  #   received_args = nil

  #   fake_service = Object.new
  #   fake_service.define_singleton_method(:generate) do |**kwargs|
  #     received_args = kwargs
  #     '文章生成結果'
  #   end

  #   AiTextService.method(:new)

  #   AiTextService.define_singleton_method(:new) do
  #     fake_service
  #   end

  #   post ai_generate_memo_path(@memo), params: {
  #     tab: 'writing',
  #     format_type: '日報',
  #     tone: '丁寧'
  #   }
  #   assert_response :success

  #   assert_equal(
  #     {
  #       tab: 'writing',
  #       content: expected_content,
  #       format: '日報',
  #       tone: '丁寧'
  #     },
  #     received_args
  #   )
  # end
end
