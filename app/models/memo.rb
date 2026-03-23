# frozen_string_literal: true

class Memo < ApplicationRecord
  has_ancestry orphan_strategy: :destroy

  belongs_to :user

  validates :title, presence: true
end
