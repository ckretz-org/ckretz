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

ActiveRecord::Schema[7.2].define(version: 2024_06_14_105028) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "access_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "token", null: false, comment: "sensitive_data=true"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.datetime "last_used_at"
    t.index ["name"], name: "index_access_tokens_on_name"
    t.index ["token"], name: "index_access_tokens_on_token"
    t.index ["user_id", "token"], name: "index_access_tokens_on_user_id_and_token"
  end

  create_table "secret_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "value", null: false, comment: "sensitive_data=true"
    t.uuid "secret_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "secret_id"], name: "index_secret_values_name_secret_id", unique: true
    t.index ["secret_id"], name: "index_secret_values_on_secret_id"
  end

  create_table "secrets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.vector "embedding", limit: 768
    t.integer "secret_values_count", default: 0
    t.index ["embedding"], name: "index_secrets_on_embedding", opclass: :vector_l2_ops, using: :hnsw
    t.index ["name"], name: "index_secrets_on_name"
    t.index ["user_id", "name"], name: "index_secrets_on_user_id_and_name", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "email", null: false, comment: "sensitive_data=true"
    t.integer "access_tokens_count", default: 0, null: false
    t.integer "secrets_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "access_tokens", "users", on_delete: :cascade
  add_foreign_key "secret_values", "secrets", on_delete: :cascade
  add_foreign_key "secrets", "users", on_delete: :cascade
end
