# frozen_string_literal: true

require 'test_helper'

class UserRegistrationsTest < ActionDispatch::IntegrationTest
  test '新規登録画面が表示される' do
    get new_user_registration_path
    assert_response :success
    assert_select 'h2', text: '新規登録'
    assert_select "input[name='user[name]']"
    assert_select "input[name='user[email]']"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']"
    assert_select "input[type='submit'][value='新規登録']"
  end

  test '名前未入力では新規登録できない' do
    assert_no_difference('User.count') do
      post user_registration_path, params: {
        user: {
          name: '',
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select 'div#error_explanation'
  end

  test '確認用パスワードが不一致なら新規登録できない' do
    assert_no_difference('User.count') do
      post user_registration_path, params: {
        user: {
          name: 'テスト太郎',
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'different_password'
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select 'div#error_explanation'
  end
end
