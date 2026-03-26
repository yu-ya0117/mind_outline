# frozen_string_literal: true

require 'test_helper'

class AiTextServiceTest < ActiveSupport::TestCase
  test 'generate がAIの返答テキストを返す' do
    fake_message = Struct.new(:content).new("```text\n- 自己理解\n```")
    fake_choice = Struct.new(:message).new(fake_message)
    fake_response = Struct.new(:choices).new([fake_choice])

    service = AiTextService.new

    service.define_singleton_method(:request_chat_completion) do |_prompt_builder|
      fake_response
    end

    result = service.generate(tab: 'organize', content: '自己理解')

    assert_equal '- 自己理解', result
  end

  test '存在しないタブでもエラーメッセージを返す' do
    result = AiTextService.new.generate(tab: 'unknown', content: '自己理解')

    assert_equal 'エラーメッセージ', result
  end

  test 'APIエラー時はエラーメッセージを返す' do
    error_client = Object.new

    def error_client.chat
      self
    end

    def error_client.completions
      self
    end

    def error_client.create(*)
      raise StandardError, 'API error'
    end

    service = AiTextService.new
    service.define_singleton_method(:client) do
      error_client
    end

    result = service.generate(tab: 'organize', content: '自己理解')

    assert_equal 'エラーメッセージ', result
  end
end
