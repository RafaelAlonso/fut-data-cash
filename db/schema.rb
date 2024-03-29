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

ActiveRecord::Schema[7.0].define(version: 2024_02_16_184350) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fixtures", force: :cascade do |t|
    t.integer "fixture_id"
    t.string "status"
    t.datetime "date_time"
    t.integer "home_score"
    t.integer "away_score"
    t.integer "season"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "home_team_id", null: false
    t.bigint "away_team_id", null: false
    t.index ["away_team_id"], name: "index_fixtures_on_away_team_id"
    t.index ["home_team_id"], name: "index_fixtures_on_home_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "position"
    t.integer "goals_scored"
    t.integer "assists"
    t.integer "dribbles"
    t.integer "tackles"
    t.integer "red_card"
    t.integer "yellow_card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.integer "external_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "city"
    t.integer "founded"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.string "logo_url"
    t.integer "external_id"
    t.string "code"
  end

  create_table "users", force: :cascade do |t|
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

  add_foreign_key "fixtures", "teams", column: "away_team_id"
  add_foreign_key "fixtures", "teams", column: "home_team_id"
  add_foreign_key "players", "teams"
end
