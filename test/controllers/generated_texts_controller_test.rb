# frozen_string_literal: true

require 'test_helper'

class GeneratedTextsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @memo = memos(:one)
  end

  test 'AI整理の生成結果を保存できる' do
    assert_difference('GeneratedText.count', 1) do
      post memo_generated_texts_path(@memo), params: {
        generated_text: {
          kind: 'organize',
          content: "- AI処理\n  - 内容: テスト"
        }
      }
    end

    generated_text = GeneratedText.last
    assert_equal @memo.id, generated_text.memo_id
    assert_equal 'organize', generated_text.kind
    assert_equal "- AI処理\n  - 内容: テスト", generated_text.content
    assert_response :redirect
  end

  test 'AI要約の生成結果を保存できる' do
    assert_difference('GeneratedText.count', 1) do
      post memo_generated_texts_path(@memo), params: {
        generated_text: {
          kind: 'summary',
          content: 'これは要約結果です。'
        }
      }
    end

    generated_text = GeneratedText.last
    assert_equal @memo.id, generated_text.memo_id
    assert_equal 'summary', generated_text.kind
    assert_equal 'これは要約結果です。', generated_text.content
    assert_response :redirect
  end

  test '文章生成の生成結果を保存できる' do
    assert_difference('GeneratedText.count', 1) do
      post memo_generated_texts_path(@memo), params: {
        generated_text: {
          kind: 'writing',
          content: 'これは文章生成結果です。'
        }
      }
    end

    generated_text = GeneratedText.last
    assert_equal @memo.id, generated_text.memo_id
    assert_equal 'writing', generated_text.kind
    assert_equal 'これは文章生成結果です。', generated_text.content
    assert_response :redirect
  end

  test 'contentが空だと保存できない' do
    assert_no_difference('GeneratedText.count') do
      post memo_generated_texts_path(@memo), params: {
        generated_text: {
          kind: 'organize',
          content: ''
        }
      }
    end

    assert_response :redirect
  end
end
