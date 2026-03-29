# frozen_string_literal: true

class GeneratedText < ApplicationRecord
  belongs_to :memo

  enum :kind, { organize: 0, summary: 1, writing: 2 }

  validates :content, presence: true
  validates :kind, presence: true

  scope :for_user, ->(user) { joins(:memo).where(memos: { user_id: user.id }) }
end
