# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AiPromptBuilder do
  describe '#user_prompt' do
    it 'includes organize format instruction when format is numbered' do
      prompt_builder = described_class.new(
        tab: 'organize',
        content: "転職したい\n年齢が不安",
        format: 'numbered'
      )

      expect(prompt_builder.user_prompt).to include('番号付き')
    end

    it 'falls back to default style when format is blank' do
      prompt_builder = described_class.new(
        tab: 'organize',
        content: "転職したい\n年齢が不安",
        format: nil
      )

      expect(prompt_builder.user_prompt).to include('シンプルで読みやすい形')
    end
  end
end
