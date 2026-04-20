# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AiTextService do
  describe '#generate' do
    subject(:result) { service.generate(**params) }

    let(:service) { described_class.new }
    let(:params) do
      {
        tab: 'unknown',
        content: '自己理解'
      }
    end

    it 'returns error message' do
      expect(result).to eq('エラーメッセージ')
    end
  end
end
