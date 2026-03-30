# frozen_string_literal: true

require 'test_helper'

class GeneratedTextsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @memo = memos(:one)
  end

  test '生成結果を保存できる' do
    cases = [
      { kind: 'organize', content: "- AI処理\n  - 内容: テスト" },
      { kind: 'summary', content: 'これは要約結果です。' },
      { kind: 'writing', content: 'これは文章生成結果です。' }
    ]

    cases.each do |item|
      assert_difference('GeneratedText.count', 1) do
        post memo_generated_texts_path(@memo), params: {
          generated_text: {
            kind: item[:kind],
            content: item[:content]
          }
        }
      end

      generated_text = GeneratedText.last
      assert_equal @memo.id, generated_text.memo_id
      assert_equal item[:kind], generated_text.kind
      assert_equal item[:content], generated_text.content
      assert_response :redirect
    end
  end

  test 'contentが空だと保存できない' do
    assert_no_difference('GeneratedText.count') do
      post memo_generated_texts_path(@memo), params: {
        generated_text: {
          kind: 'organize',
          content: ''
        },
        tab: 'organize'
      }
    end

    assert_response :unprocessable_entity
    assert_match '生成結果の保存に失敗しました', response.body
  end

  test '生成結果保存履歴一覧を表示できる' do
    get memo_generated_texts_path(@memo)
    assert_response :success
    assert_match '生成結果保存履歴', response.body
  end

  test '生成結果詳細を表示できる' do
    generated_text = generated_texts(:one)

    get memo_generated_text_path(generated_text.memo, generated_text)
    assert_response :success
    assert_match '生成結果詳細', response.body
    assert_match generated_text.content, response.body
  end

  test '生成結果を保存できたらメモ詳細画面へリダイレクトし、flashが表示される' do
    assert_difference('GeneratedText.count', 1) do
      post memo_generated_texts_path(@memo), params: {
        generated_text: {
          content: '生成された文章です',
          kind: 'writing'
        },
        tab: 'writing'
      }
    end

    assert_redirected_to memo_path(@memo)
    follow_redirect!
    assert_match '生成結果を保存しました', response.body
  end

  test '生成結果の保存に失敗したらai_toolsを再表示する' do
    assert_no_difference('GeneratedText.count') do
      post memo_generated_texts_path(@memo), params: {
        generated_text: {
          content: '',
          kind: 'writing'
        },
        tab: 'writing'
      }
    end

    assert_response :unprocessable_entity
    assert_match '生成結果の保存に失敗しました', response.body
  end
end
