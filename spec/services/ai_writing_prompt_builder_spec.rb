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

    it 'includes consultation instruction when format is consultation' do
      prompt = described_class.new(
        content: '転職について相談したい',
        format: 'consultation',
        tone: 'polite'
      ).build

      expect(prompt).to include('相談文')
      expect(prompt).to include('【背景】')
      expect(prompt).to include('丁寧')
    end

    it 'includes report instruction when format is report' do
      prompt = described_class.new(
        content: 'Railsアプリの進捗を報告したい',
        format: 'report',
        tone: 'casual'
      ).build

      expect(prompt).to include('報告文')
      expect(prompt).to include('【概要】')
      expect(prompt).to include('ややカジュアル')
    end
  end
end
