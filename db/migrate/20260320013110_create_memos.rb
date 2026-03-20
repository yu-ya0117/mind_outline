# frozen_string_literal: true

class CreateMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :memos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content
      t.string :ancestry

      t.timestamps
    end

    add_index :memos, :ancestry
  end
end
