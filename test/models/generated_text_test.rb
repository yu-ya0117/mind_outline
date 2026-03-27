# frozen_string_literal: true

require 'test_helper'

class GeneratedTextTest < ActiveSupport::TestCase
  test 'contentがあれば有効' do
    generated_text = GeneratedText.new(memo: memos(:one), kind: :organize, content: 'テスト')
    assert generated_text.valid?
  end

  test 'contentがなければ無効' do
    generated_text = GeneratedText.new(memo: memos(:one), kind: :organize, content: nil)
    assert_not generated_text.valid?
  end
end
