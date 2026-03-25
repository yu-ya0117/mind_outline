# frozen_string_literal: true

class Memo < ApplicationRecord
  has_ancestry orphan_strategy: :destroy

  belongs_to :user

  validates :title, presence: true

  def ai_source_text
    [title, content].reject(&:blank?).join("\n")
  end
end
