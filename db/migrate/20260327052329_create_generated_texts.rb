# frozen_string_literal: true

class CreateGeneratedTexts < ActiveRecord::Migration[7.2]
  def change
    create_table :generated_texts do |t|
      t.references :memo, null: false, foreign_key: true
      t.integer :kind, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
