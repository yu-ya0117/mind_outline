# frozen_string_literal: true

require 'application_system_test_case'

class MemosTreeEditTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @root_memo = memos(:one)
  end

  test '子メモの編集ボタンから編集画面へ遷移できる' do
    sign_in @user

    child = @root_memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    visit memo_path(@root_memo)

    within("#memo_#{child.id}") do
      click_on '編集'
    end

    assert_current_path edit_memo_path(child)
    assert_text 'メモ編集'
    assert_field 'タイトル', with: child.title
    assert_field '内容', with: child.content
  end

  test '孫メモの編集ボタンから編集画面へ遷移できる' do
    sign_in @user

    child = @root_memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    grandchild = child.children.create!(
      user: @user,
      title: '孫メモ',
      content: '孫メモ内容'
    )

    visit memo_path(@root_memo)

    within("#memo_#{grandchild.id}") do
      click_on '編集'
    end

    assert_current_path edit_memo_path(grandchild)
    assert_text 'メモ編集'
    assert_field 'タイトル', with: grandchild.title
    assert_field '内容', with: grandchild.content
  end

  test '編集画面では編集中のメモだけ強調表示される' do
    sign_in @user

    child = @root_memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    grandchild = child.children.create!(
      user: @user,
      title: '孫メモ',
      content: '孫メモ内容'
    )

    visit edit_memo_path(child)

    assert_text @root_memo.title
    assert_text child.title
    assert_text grandchild.title

    assert_selector '.current-memo', text: child.title
    assert_no_selector '.current-memo', text: @root_memo.title
    assert_no_selector '.current-memo', text: grandchild.title
  end

  test '詳細画面では編集中強調表示が出ない' do
    sign_in @user

    child = @root_memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    visit memo_path(@root_memo)

    assert_text @root_memo.title
    assert_text child.title
    assert_no_selector '.current-memo'
  end
end
