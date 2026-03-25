# frozen_string_literal: true

require 'test_helper'

class AiTextServiceTest < ActiveSupport::TestCase
  FakeResponse = Struct.new(:output_text)

  class FakeResponses
    def initialize(text = nil, error: nil)
      @text = text
      @error = error
    end

    def create(**)
      raise @error if @error

      FakeResponse.new(@text)
    end
  end

  class FakeClient
    attr_reader :responses

    def initialize(text = nil, error: nil)
      @responses = FakeResponses.new(text, error: error)
    end
  end

  test 'generate がAIの返答テキストを返す' do
    fake_client = FakeClient.new('生成結果テスト')

    result = AiTextService.generate(
      tab: 'organize',
      source_text: '元メモ本文',
      user_prompt: '整理してください',
      client: fake_client
    )

    assert_equal '生成結果テスト', result
  end

  test '存在しないタブでもエラーにならず結果を返す' do
    fake_client = FakeClient.new('デフォルト結果')

    result = AiTextService.generate(
      tab: 'unknown',
      source_text: '元メモ本文',
      user_prompt: '自由に処理してください',
      client: fake_client
    )

    assert_equal 'デフォルト結果', result
  end

  test 'APIエラー時はエラーメッセージを返す' do
    fake_client = FakeClient.new(nil, error: StandardError.new('接続失敗'))

    result = AiTextService.generate(
      tab: 'organize',
      source_text: '元メモ本文',
      user_prompt: '整理してください',
      client: fake_client
    )

    assert_match 'AI生成中にエラーが発生しました', result
    assert_match '接続失敗', result
  end
end
