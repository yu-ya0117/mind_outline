# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AiTextService do
  describe '#generate' do
    subject(:result) { service.generate(**params) }

    let(:service) { described_class.new }
    let(:params) do
      {
        tab: 'organize',
        content: '自己理解'
      }
    end

    before do
      allow(service).to receive(:request_chat_completion)
        .and_return(build_openai_response("```text\n- 自己理解\n```"))
    end

    it 'returns cleaned response text' do
      expect(result).to eq('- 自己理解')
    end
  end
end
