# frozen_string_literal: true

require 'test_helper'

class MemosTreeDisplayTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @memo = memos(:one)
  end

  test 'メモ詳細画面に複数の子メモが表示される' do
    sign_in @user

    child1 = @memo.children.create!(
      user: @user,
      title: '子メモ1',
      content: '子メモ内容1'
    )

    child2 = @memo.children.create!(
      user: @user,
      title: '子メモ2',
      content: '子メモ内容2'
    )

    get memo_url(@memo)
    assert_response :success
    assert_match child1.title, response.body
    assert_match child1.content, response.body
    assert_match child2.title, response.body
    assert_match child2.content, response.body
  end

  test 'メモ詳細画面で孫メモまでツリー表示される' do
    sign_in @user

    child = @memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    grandchild = child.children.create!(
      user: @user,
      title: '孫メモ',
      content: '孫メモ内容'
    )

    get memo_url(@memo)
    assert_response :success
    assert_match @memo.title, response.body
    assert_match child.title, response.body
    assert_match child.content, response.body
    assert_match grandchild.title, response.body
    assert_match grandchild.content, response.body
  end

  test 'メモ編集画面で孫メモまでツリー表示される' do
    sign_in @user

    child = @memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    grandchild = child.children.create!(
      user: @user,
      title: '孫メモ',
      content: '孫メモ内容'
    )

    get edit_memo_url(@memo)
    assert_response :success
    assert_match @memo.title, response.body
    assert_match child.title, response.body
    assert_match child.content, response.body
    assert_match grandchild.title, response.body
    assert_match grandchild.content, response.body
  end
end
