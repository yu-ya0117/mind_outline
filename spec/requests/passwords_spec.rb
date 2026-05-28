# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe 'GET /users/password/new' do
    it 'displays password reset request page' do
      get new_user_password_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('パスワード再設定')
      expect(response.body).to include('再設定メールを送信')
    end
  end

  describe 'POST /users/password' do
    it 'sends reset password instructions to registered email' do
      user = User.create!(
        name: 'テストユーザー',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )

      post user_password_path, params: {
        user: {
          email: user.email
        }
      }

      mail = ActionMailer::Base.deliveries.last

      expect(mail).to be_present
      expect(mail.to).to include(user.email)
      expect(user.reload.reset_password_token).to be_present
    end
  end

  describe 'GET /users/password/edit' do
    let!(:user) do
      User.create(
        name: 'テストユーザー',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end
    it 'displays password reset edit page with valid token' do
      raw_token = user.send_reset_password_instructions

      get edit_user_password_path(reset_password_token: raw_token)

      expect(response).to have_http_status(:success)
      expect(response.body).to include('新しいパスワード')
    end
  end

  describe 'PUT /users/password' do
    it 'updates password with valid reset password token' do
      user = User.create!(
        name: 'テストユーザー',
        email: 'test@example.com',
        password: 'old_password',
        password_confirmation: 'old_password'
      )

      raw_token = user.send_reset_password_instructions

      put user_password_path, params: {
        user: {
          reset_password_token: raw_token,
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      }

      expect(response).to have_http_status(:redirect)

      user.reload
      expect(user.valid_password?('new_password')).to be true
      expect(user.valid_password?('old_password')).to be false
    end
  end
end
