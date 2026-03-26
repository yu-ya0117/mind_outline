# frozen_string_literal: true

require 'test_helper'

class MemosAiGenerateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @memo = memos(:one)
    sign_in @user
  end

  test 'ai_generate は organize のとき ai_tree_source_text を使う' do
    received_args_holder = {}
    fake_service = build_fake_service('- 整理結果', received_args_holder)

    with_stubbed_ai_text_service(fake_service) do
      post ai_generate_memo_path(@memo), params: { tab: 'organize' }
      assert_response :success
    end

    assert_equal expected_organize_args, received_args_holder[:value]
  end

  test 'ai_generate は summary のとき ai_source_text を使う' do
    received_args_holder = {}
    fake_service = build_fake_service('要約結果', received_args_holder)

    with_stubbed_ai_text_service(fake_service) do
      post ai_generate_memo_path(@memo), params: { tab: 'summary' }
      assert_response :success
    end

    assert_equal expected_summary_args, received_args_holder[:value]
  end

  test 'ai_generate は writing のとき format と tone を渡す' do
    received_args_holder = {}
    fake_service = build_fake_service('文章生成結果', received_args_holder)

    with_stubbed_ai_text_service(fake_service) do
      post ai_generate_memo_path(@memo), params: {
        tab: 'writing',
        format_type: '日報',
        tone: '丁寧'
      }
      assert_response :success
    end

    assert_equal expected_writing_args, received_args_holder[:value]
  end

  private

  def build_fake_service(result_text, received_args_holder)
    fake_service = Object.new
    fake_service.define_singleton_method(:generate) do |**kwargs|
      received_args_holder[:value] = kwargs
      result_text
    end
    fake_service
  end

  def with_stubbed_ai_text_service(fake_service)
    original_new = AiTextService.method(:new)

    AiTextService.define_singleton_method(:new) do
      fake_service
    end

    yield
  ensure
    AiTextService.define_singleton_method(:new, original_new)
  end

  def expected_organize_args
    {
      tab: 'organize',
      content: @memo.ai_tree_source_text,
      format: nil,
      tone: nil
    }
  end

  def expected_summary_args
    {
      tab: 'summary',
      content: @memo.ai_source_text,
      format: nil,
      tone: nil
    }
  end

  def expected_writing_args
    {
      tab: 'writing',
      content: @memo.ai_source_text,
      format: '日報',
      tone: '丁寧'
    }
  end
end
