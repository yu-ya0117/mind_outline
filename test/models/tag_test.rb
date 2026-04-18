# frozen_string_literal: true

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: 'テストユーザー',
      email: 'tag_user1@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )

    @other_user = User.create!(
      name: '別ユーザー',
      email: 'tag_user2@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test '有効なタグを作成できる' do
    tag = Tag.new(user: @user, name: 'Rails')
    assert tag.valid?
  end

  test 'nameが空では無効' do
    tag = Tag.new(user: @user, name: '')
    assert_not tag.valid?
    assert_includes tag.errors[:name], 'を入力してください'
  end

  test '同一ユーザーは同じ名前のタグを作成できない' do
    Tag.create!(user: @user, name: 'Rails')

    duplicate_tag = Tag.new(user: @user, name: 'Rails')
    assert_not duplicate_tag.valid?
    assert_includes duplicate_tag.errors[:name], 'はすでに存在します'
  end

  test '別ユーザーなら同じ名前のタグを作成できる' do
    Tag.create!(user: @user, name: 'Rails')

    other_user_tag = Tag.new(user: @other_user, name: 'Rails')
    assert other_user_tag.valid?
  end
end
