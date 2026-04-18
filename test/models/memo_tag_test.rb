# frozen_string_literal: true

require 'test_helper'

class MemoTagTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: 'テストユーザー',
      email: 'memo_tag_user@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )

    @memo = Memo.create!(
      user: @user,
      title: 'テストメモ',
      content: 'テスト内容'
    )

    @tag = Tag.create!(
      user: @user,
      name: 'Rails'
    )
  end

  test '有効な関連付けを作成できる' do
    memo_tag = MemoTag.new(memo: @memo, tag: @tag)
    assert memo_tag.valid?
  end

  test '同じメモに同じタグを重複して付与できない' do
    MemoTag.create!(memo: @memo, tag: @tag)

    duplicate_memo_tag = MemoTag.new(memo: @memo, tag: @tag)
    assert_not duplicate_memo_tag.valid?
    assert_includes duplicate_memo_tag.errors[:memo_id], 'はすでに存在します'
  end
end
