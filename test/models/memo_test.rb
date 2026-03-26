# frozen_string_literal: true

require 'test_helper'

class MemoTest < ActiveSupport::TestCase
  test 'ai_source_text は title と content を整形して返す' do
    memo = Memo.new(title: '自己理解', content: '心理学の観点から整理する')

    expected = <<~TEXT.strip
      タイトル: 自己理解
      内容: 心理学の観点から整理する
    TEXT

    assert_equal expected, memo.ai_source_text
  end

  test 'ai_source_text は content がなくても title だけ返す' do
    memo = Memo.new(title: '自己理解', content: nil)

    assert_equal 'タイトル: 自己理解', memo.ai_source_text
  end

  test 'ai_tree_source_text は子メモを含めたツリー文字列を返す' do
    parent = build_ai_tree_source_text_memos

    assert_equal expected_ai_tree_source_text, parent.ai_tree_source_text
  end

  private

  def build_ai_tree_source_text_memos
    parent = create_memo(
      title: 'Rails学習',
      content: '導入から卒業制作まで'
    )

    create_root_children(parent)

    parent
  end

  def create_root_children(parent)
    create_memo(title: 'メモCRUD', content: 'ツリー状で表示', parent: parent)

    create_ai_processing_children(
      create_memo(
        title: 'AI処理',
        content: 'OpenAI APIを使用して整理・要約・文章生成を行う。',
        parent: parent
      )
    )
  end

  def create_ai_processing_children(parent)
    create_memo(
      title: 'AI整理',
      content: '思考整理の構造化を行う。',
      parent: parent
    )
  end

  def create_memo(attrs)
    Memo.create!({ user: users(:one) }.merge(attrs))
  end

  def expected_ai_tree_source_text
    <<~TEXT.strip
      - タイトル: Rails学習
        内容: 導入から卒業制作まで
        - タイトル: メモCRUD
          内容: ツリー状で表示
        - タイトル: AI処理
          内容: OpenAI APIを使用して整理・要約・文章生成を行う。
          - タイトル: AI整理
            内容: 思考整理の構造化を行う。
    TEXT
  end
end
