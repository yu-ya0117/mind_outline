# frozen_string_literal: true

class Memo < ApplicationRecord
  has_ancestry

  belongs_to :user

  validates :title, presence: true
end
