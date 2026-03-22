# frozen_string_literal: true

require 'test_helper'

class TimeZoneTest < ActiveSupport::TestCase
  test 'application time zone is Tokyo' do
    assert_equal 'Tokyo', Rails.application.config.time_zone
  end
end
