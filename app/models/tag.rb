class Tag < ApplicationRecord
  belongs_to :user

  has_many :memo_tags, dependent: :destroy
  has_many :memos, through: :memo_tags

  validates :name, presence: true,
                   uniqueness: { scope: :user_id },
                   length: { maximum: 30 }
end
