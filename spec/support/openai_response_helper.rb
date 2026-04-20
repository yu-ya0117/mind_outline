# frozen_string_literal: true

module OpenaiResponseHelper
  def build_openai_response(content)
    message = Struct.new(:content).new(content)
    choice = Struct.new(:message).new(message)
    Struct.new(:choices).new([choice])
  end
end

RSpec.configure do |config|
  config.include OpenaiResponseHelper
end
