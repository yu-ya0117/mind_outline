# frozen_string_literal: true

class FailingOpenaiClient
  def chat
    self
  end

  def completions
    self
  end

  def create(*)
    raise StandardError, 'API error'
  end
end
