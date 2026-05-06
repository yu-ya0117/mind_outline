# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MemosAiTools', type: :request do
  describe 'GET /memos/:id/ai_tools' do
    it 'displays AI tools page' do
      user = User.create!(
        name: 'テストユーザー',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )

      memo = Memo.create!(
        user: user,
        title: 'テストメモ',
        content: 'テスト内容'
      )

      sign_in user

      get ai_tools_memo_path(memo)

      expect(response).to have_http_status(:success)
      expect(response.body).to include('AI処理')
      expect(response.body).to include('生成する')
    end
  end
end
