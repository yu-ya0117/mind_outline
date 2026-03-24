# frozen_string_literal: true

require 'application_system_test_case'

class MemosHomeTreeTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @root_memo = memos(:one)
  end

  test 'ホーム画面で親メモをクリックすると子メモが表示される' do
    sign_in @user

    child = @root_memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    visit memos_path

    assert_text @root_memo.title
    assert_no_text child.title

    click_on @root_memo.title

    assert_text child.title
  end

  test 'ホーム画面で子メモをクリックすると孫メモが表示される' do
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

    visit memos_path

    assert_text @root_memo.title
    assert_no_text child.title
    assert_no_text grandchild.title

    click_on @root_memo.title
    assert_text child.title
    assert_no_text grandchild.title

    click_on child.title
    assert_text grandchild.title
  end

  test 'ホーム画面で再度クリックすると子メモが閉じる' do
    sign_in @user

    child = @root_memo.children.create!(
      user: @user,
      title: '子メモ',
      content: '子メモ内容'
    )

    visit memos_path

    click_on @root_memo.title
    assert_text child.title

    click_on @root_memo.title
    assert_no_text child.title
  end
end
