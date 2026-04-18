# frozen_string_literal: true

class MemoUpdater
  def initialize(memo:, memo_params:, tag_names:, user:)
    @memo = memo
    @memo_params = memo_params
    @tag_names = tag_names
    @user = user
  end

  def call
    ActiveRecord::Base.transaction do
      memo.update!(memo_params)
      memo.tags = build_tags
    end

    memo
  end

  private

  attr_reader :memo, :memo_params, :tag_names, :user

  def build_tags
    parsed_tag_names.map do |tag_name|
      user.tags.find_or_create_by!(name: tag_name)
    end
  end

  def parsed_tag_names
    tag_names.to_s.split(',').map(&:strip).reject(&:blank?).uniq
  end
end
