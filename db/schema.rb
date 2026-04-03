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

ActiveRecord::Schema[7.2].define(version: 2026_04_03_124110) do
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
    t.index ["study_unit_id"], name: "index_characters_on_study_unit_id"
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
    t.index ["category_id"], name: "index_events_on_category_id"
    t.index ["period_id"], name: "index_events_on_period_id"
    t.index ["study_unit_id"], name: "index_events_on_study_unit_id"
  end

  create_table "periods", force: :cascade do |t|
    t.string "name"
  end

  create_table "study_units", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "characters", "study_units"
  add_foreign_key "event_characters", "characters"
  add_foreign_key "event_characters", "events"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "periods"
  add_foreign_key "events", "study_units"
end
