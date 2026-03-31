# frozen_string_literal: true

class GeneratedText < ApplicationRecord
  belongs_to :memo

  enum :kind, { organize: 0, summary: 1, writing: 2 }

  validates :content, presence: true
  validates :kind, presence: true

  scope :recent_first, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { joins(:memo).where(memos: { user_id: user.id }) }
  scope :for_memo_subtree, ->(memo) { where(memo_id: memo.subtree_ids) }

  def self.for_history_index(user:, memo: nil)
    records = for_user(user)
    records = records.for_memo_subtree(memo) if memo.present?
    records.recent_first
  end
end
