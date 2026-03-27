# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 20_260_327_052_329) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'generated_texts', force: :cascade do |t|
    t.bigint 'memo_id', null: false
    t.integer 'kind', null: false
    t.text 'content', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['memo_id'], name: 'index_generated_texts_on_memo_id'
  end

  create_table 'memos', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.string 'title', null: false
    t.text 'content'
    t.string 'ancestry'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['ancestry'], name: 'index_memos_on_ancestry'
    t.index ['user_id'], name: 'index_memos_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.datetime 'remember_created_at'
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  add_foreign_key 'generated_texts', 'memos'
  add_foreign_key 'memos', 'users'
end
