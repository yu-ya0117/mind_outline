# frozen_string_literal: true

require 'application_system_test_case'

class MvpLayoutNavigationTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  setup do
    @user = users(:one)
    @memo = memos(:one)
    @generated_text = generated_texts(:one)
    login_as(@user, scope: :user)
  end

  teardown do
    Warden.test_reset!
  end

  test 'AI処理画面で対象メモが表示され、戻る導線がある' do
    visit ai_tools_memo_path(@memo)

    assert_text 'AI処理'
    assert_text @memo.title
    assert_text 'このメモに対してAI整理・要約・文章生成を行います'

    assert_link 'メモ詳細に戻る', href: memo_path(@memo)
    assert_link 'メモ一覧へ戻る', href: memos_path
  end

  test '生成結果詳細画面から生成結果保存履歴へ戻れる' do
    visit memo_generated_text_path(@generated_text.memo, @generated_text)

    assert_text '生成結果詳細'
    assert_text @generated_text.content

    click_on '生成結果保存履歴へ戻る'

    assert_current_path memo_generated_texts_path(@generated_text.memo)
    assert_text '生成結果保存履歴'
  end
end
