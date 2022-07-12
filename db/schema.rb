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

ActiveRecord::Schema[7.0].define(version: 2022_07_06_185256) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_roles", force: :cascade do |t|
    t.integer "role"
    t.bigint "user_id"
    t.bigint "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_board_roles_on_board_id"
    t.index ["user_id", "board_id"], name: "index_board_roles_on_user_id_and_board_id", unique: true
    t.index ["user_id"], name: "index_board_roles_on_user_id"
  end

  create_table "boards", force: :cascade do |t|
    t.string "short_name", limit: 4, null: false
    t.string "name", limit: 16, null: false
    t.string "description", limit: 128
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_name"], name: "index_boards_on_short_name", unique: true
  end

  create_table "comment_threads", force: :cascade do |t|
    t.boolean "sticky", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bump_count", default: 0, null: false
    t.datetime "last_bump"
    t.bigint "board_id", null: false
    t.integer "comments_count"
    t.boolean "locked"
    t.index ["board_id"], name: "index_comment_threads_on_board_id"
    t.index ["last_bump"], name: "index_comment_threads_on_last_bump"
  end

  create_table "comments", force: :cascade do |t|
    t.string "content", limit: 1024, null: false
    t.boolean "anonymous", default: true, null: false
    t.string "anon_name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "comment_thread_id"
    t.text "image_data"
    t.index ["comment_thread_id"], name: "index_comments_on_comment_thread_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "username"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "board_roles", "boards", on_delete: :cascade
  add_foreign_key "board_roles", "users", on_delete: :cascade
  add_foreign_key "comment_threads", "boards", on_delete: :cascade
  add_foreign_key "comments", "comment_threads"
  add_foreign_key "comments", "users", on_delete: :cascade
end
