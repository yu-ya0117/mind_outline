# frozen_string_literal: true

require 'test_helper'

class MemoTagsFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test 'タグ付きで新規メモを作成できる' do
    assert_difference('Memo.count', 1) do
      assert_difference('Tag.count', 3) do
        post memos_path, params: {
          memo: {
            title: 'タグ付きメモ',
            content: 'テスト内容'
          },
          tag_names: 'Rails_test_1, Ruby_test_1, Webアプリ_test_1'
        }
      end
    end

    memo = Memo.order(:created_at).last

    assert_redirected_to memos_path
    assert_equal %w[Rails_test_1 Ruby_test_1 Webアプリ_test_1].sort,
                 memo.tags.pluck(:name).sort
  end

  test 'メモ更新時にタグを更新できる' do
    memo = Memo.create!(
      user: @user,
      title: '更新前メモ',
      content: '更新前の内容'
    )

    old_tag = Tag.create!(user: @user, name: 'OldTag_test')
    memo.tags << old_tag

    assert_no_difference('Memo.count') do
      assert_difference('Tag.count', 2) do
        patch memo_path(memo), params: {
          memo: {
            title: '更新後メモ',
            content: '更新後の内容'
          },
          tag_names: 'NewTag_test, AnotherTag_test'
        }
      end
    end

    memo.reload

    assert_redirected_to memo_path(memo)
    assert_equal '更新後メモ', memo.title
    assert_equal '更新後の内容', memo.content
    assert_equal %w[AnotherTag_test NewTag_test].sort, memo.tags.pluck(:name).sort
  end

  test 'タグでメモを絞り込みできる' do
    rails_tag = Tag.create!(user: @user, name: 'Rails_filter_test')
    ruby_tag = Tag.create!(user: @user, name: 'Ruby_filter_test')

    memo1 = Memo.create!(
      user: @user,
      title: 'Railsメモ',
      content: 'Railsの内容'
    )
    memo2 = Memo.create!(
      user: @user,
      title: 'Rubyメモ',
      content: 'Rubyの内容'
    )

    memo1.tags << rails_tag
    memo2.tags << ruby_tag

    get memos_path, params: { tag: 'Rails_filter_test' }

    assert_response :success
    assert_match 'Railsメモ', response.body
    assert_no_match 'Rubyメモ', response.body
    assert_match 'Rails_filter_test', response.body
  end
end
