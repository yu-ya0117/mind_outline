# frozen_string_literal: true

class MemoCreator
  def initialize(user:, memo_params:, tag_names:)
    @user = user
    @memo_params = memo_params
    @tag_names = tag_names
  end

  def call
    memo = @user.memos.build(@memo_params)

    ActiveRecord::Base.transaction do
      memo.save!
      memo.tags << build_tags
    end

    memo
  end

  private

  attr_reader :user, :memo_params, :tag_names

  def build_tags
    parsed_tag_names.map do |tag_name|
      user.tags.find_or_create_by!(name: tag_name)
    end
  end

  def parsed_tag_names
    tag_names.to_s.split(',').map(&:strip).reject(&:blank?).uniq
  end
end
