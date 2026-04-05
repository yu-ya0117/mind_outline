# frozen_string_literal: true

require 'test_helper'

class UserRememberMeTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: 'hoge',
      email: 'remember_test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test 'remember_meをオンにしてログインするとremember_created_atが設定される' do
    assert_nil @user.remember_created_at

    post user_session_path, params: {
      user: {
        email: @user.email,
        password: 'password123',
        remember_me: '1'
      }
    }

    assert_response :redirect
    follow_redirect!

    @user.reload
    assert_not_nil @user.remember_created_at
  end

  test 'remember_meをオフにしてログインするとremember_created_atは設定されない' do
    assert_nil @user.remember_created_at

    post user_session_path, params: {
      user: {
        email: @user.email,
        password: 'password123',
        remember_me: '0'
      }
    }

    assert_response :redirect
    follow_redirect!

    @user.reload
    assert_nil @user.remember_created_at
  end
end
