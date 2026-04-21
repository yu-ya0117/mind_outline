# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AiWritingPromptBuilder do
  describe '#build' do
    it 'includes daily report instruction when format is daily_report' do
      prompt = described_class.new(
        content: '今日はRSpec導入を行った',
        format: 'daily_report',
        tone: 'casual'
      ).build

      expect(prompt).to include('日報')
      expect(prompt).to include('【本日の作業】')
      expect(prompt).to include('ややカジュアル')
    end
  end
end