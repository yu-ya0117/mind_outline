# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /terms' do
    it 'returns http success and displays terms page' do
      get terms_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('利用規約')
    end
  end

  describe 'GET /privacy' do
    it 'returns http success and displays privacy page' do
      get privacy_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('プライバシーポリシー')
    end
  end
end
