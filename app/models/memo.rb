# frozen_string_literal: true

class Memo < ApplicationRecord
  has_ancestry

  belongs_to :user

  validates :title, presence: true

  def ai_source_text
    lines = []
    lines << "タイトル: #{title}" if title.present?
    lines << "内容: #{content}" if content.present?
    lines.join("\n")
  end

  def ai_tree_source_text(depth = 0)
    lines = []
    indent = '  ' * depth

    lines << "#{indent}- タイトル: #{title}" if title.present?
    lines << "#{indent}  内容: #{content}" if content.present?

    children.order(:created_at).each do |child|
      lines << child.ai_tree_source_text(depth + 1)
    end

    lines.join("\n")
  end
end
