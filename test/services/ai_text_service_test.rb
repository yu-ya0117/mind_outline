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
    fake_message = Struct.new(:content).new('- 自己理解')
    fake_choice = Struct.new(:message).new(fake_message)
    fake_response = Struct.new(:choices).new([fake_choice])

    service = AiTextService.new

    service.define_singleton_method(:request_chat_completion) do |**_kwargs|
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
