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

ActiveRecord::Schema[7.2].define(version: 2026_04_12_000005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "achievement"
    t.bigint "study_unit_id", null: false
    t.string "image_url"
    t.integer "year"
    t.bigint "period_id"
    t.bigint "region_id"
    t.string "image_credit"
    t.index ["period_id"], name: "index_characters_on_period_id"
    t.index ["region_id"], name: "index_characters_on_region_id"
    t.index ["study_unit_id"], name: "index_characters_on_study_unit_id"
  end

  create_table "choices", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "body", null: false
    t.boolean "correct_answer", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "event_characters", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "character_id", null: false
    t.index ["character_id"], name: "index_event_characters_on_character_id"
    t.index ["event_id", "character_id"], name: "index_event_characters_on_event_id_and_character_id", unique: true
    t.index ["event_id"], name: "index_event_characters_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.bigint "period_id", null: false
    t.bigint "category_id", null: false
    t.text "description"
    t.bigint "study_unit_id", null: false
    t.string "image_url"
    t.bigint "region_id"
    t.string "image_credit"
    t.index ["category_id"], name: "index_events_on_category_id"
    t.index ["period_id"], name: "index_events_on_period_id"
    t.index ["region_id"], name: "index_events_on_region_id"
    t.index ["study_unit_id"], name: "index_events_on_study_unit_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "favorable_type", null: false
    t.bigint "favorable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favorable_type", "favorable_id"], name: "index_favorites_on_favorable"
    t.index ["user_id", "favorable_type", "favorable_id"], name: "index_favorites_on_user_id_and_favorable_type_and_favorable_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "periods", force: :cascade do |t|
    t.string "name"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quiz_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_quiz_categories_on_name", unique: true
  end

  create_table "quiz_results", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "quiz_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "score"
    t.integer "correct_count"
    t.integer "total_correct"
    t.date "test_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_results_on_quiz_id"
    t.index ["user_id", "quiz_id"], name: "index_quiz_results_on_user_id_and_quiz_id", unique: true
    t.index ["user_id"], name: "index_quiz_results_on_user_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "quiz_category_id", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_category_id"], name: "index_quizzes_on_quiz_category_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "daily_study_hours", default: 1, null: false
    t.integer "weekdays", default: [], array: true
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "study_unit_schedules", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.bigint "study_unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id", "study_unit_id"], name: "index_study_unit_schedules_on_schedule_id_and_study_unit_id", unique: true
    t.index ["schedule_id"], name: "index_study_unit_schedules_on_schedule_id"
    t.index ["study_unit_id"], name: "index_study_unit_schedules_on_study_unit_id"
  end

  create_table "study_units", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "characters", "periods"
  add_foreign_key "characters", "regions"
  add_foreign_key "characters", "study_units"
  add_foreign_key "choices", "questions"
  add_foreign_key "event_characters", "characters"
  add_foreign_key "event_characters", "events"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "periods"
  add_foreign_key "events", "regions"
  add_foreign_key "events", "study_units"
  add_foreign_key "favorites", "users"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quiz_results", "quizzes"
  add_foreign_key "quiz_results", "users"
  add_foreign_key "quizzes", "quiz_categories"
  add_foreign_key "schedules", "users"
  add_foreign_key "study_unit_schedules", "schedules"
  add_foreign_key "study_unit_schedules", "study_units"
end
