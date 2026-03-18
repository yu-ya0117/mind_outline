# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'is invalid without name' do
    user = User.new(email: 'test@example.com', password: 'password')
    assert_not user.valid?
  end
end
