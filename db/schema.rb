# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120923210908) do

  create_table "accounts", :primary_key => "account_id", :force => true do |t|
    t.string  "account_nm", :limit => 30, :null => false
    t.integer "balance",                  :null => false
  end

  create_table "conferences", :primary_key => "conference_id", :force => true do |t|
    t.string "conference_nm", :limit => 30, :null => false
  end

  create_table "game_lines", :primary_key => "game_line_id", :force => true do |t|
    t.integer   "game_id",                                                      :null => false
    t.integer   "sportsbook_id",                                                :null => false
    t.decimal   "home_spread",   :precision => 3, :scale => 1,                  :null => false
    t.integer   "vig",                                                          :null => false
    t.timestamp "load_dt",                                                      :null => false
    t.decimal   "over_under",    :precision => 4, :scale => 1, :default => 0.0
  end

  add_index "game_lines", ["game_id", "sportsbook_id", "load_dt"], :name => "game_id", :unique => true
  add_index "game_lines", ["sportsbook_id"], :name => "sportsbook_id"

  create_table "games", :primary_key => "game_id", :force => true do |t|
    t.integer   "season",       :null => false
    t.integer   "wk",           :null => false
    t.integer   "away_team_id", :null => false
    t.integer   "home_team_id", :null => false
    t.integer   "away_score"
    t.integer   "home_score"
    t.timestamp "game_time",    :null => false
  end

  add_index "games", ["away_team_id"], :name => "away_team_id"
  add_index "games", ["home_team_id"], :name => "home_team_id"

  create_table "ranks", :primary_key => "rank_id", :force => true do |t|
    t.integer "team_id", :null => false
    t.integer "season",  :null => false
    t.integer "wk",      :null => false
    t.integer "rank",    :null => false
  end

  add_index "ranks", ["rank", "season", "wk"], :name => "rank", :unique => true
  add_index "ranks", ["team_id", "season", "wk"], :name => "team_id", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sportsbooks", :primary_key => "sportsbook_id", :force => true do |t|
    t.string "sportsbook_nm", :limit => 30, :null => false
  end

  create_table "stats", :primary_key => "stat_id", :force => true do |t|
    t.integer "team_id",                                 :null => false
    t.integer "season",                                  :null => false
    t.integer "wk",                                      :null => false
    t.integer "oyards",                                  :null => false
    t.decimal "oyards_pg", :precision => 8, :scale => 1, :null => false
    t.integer "opass",                                   :null => false
    t.decimal "opass_pg",  :precision => 8, :scale => 1, :null => false
    t.decimal "opass_rtg", :precision => 8, :scale => 1, :null => false
    t.integer "orush",                                   :null => false
    t.decimal "orush_pg",  :precision => 8, :scale => 1, :null => false
    t.integer "opts",                                    :null => false
    t.decimal "opts_pg",   :precision => 8, :scale => 1, :null => false
    t.integer "dyards",                                  :null => false
    t.decimal "dyards_pg", :precision => 8, :scale => 1, :null => false
    t.integer "dpass",                                   :null => false
    t.decimal "dpass_pg",  :precision => 8, :scale => 1, :null => false
    t.integer "drush",                                   :null => false
    t.decimal "drush_pg",  :precision => 8, :scale => 1, :null => false
    t.integer "dpts",                                    :null => false
    t.decimal "dpts_pg",   :precision => 8, :scale => 1, :null => false
  end

  add_index "stats", ["team_id", "season", "wk"], :name => "team_id", :unique => true

  create_table "teams", :primary_key => "team_id", :force => true do |t|
    t.string  "school_nm",     :limit => 30, :null => false
    t.string  "team_nm",       :limit => 30, :null => false
    t.string  "abbreviation",  :limit => 6,  :null => false
    t.integer "conference_id"
  end

  add_index "teams", ["conference_id"], :name => "conference_id"

  create_table "wagers", :primary_key => "wager_id", :force => true do |t|
    t.integer "game_line_id",              :null => false
    t.integer "account_id",                :null => false
    t.string  "team",         :limit => 5, :null => false
    t.integer "amount",                    :null => false
  end

  add_index "wagers", ["account_id"], :name => "account_id"
  add_index "wagers", ["game_line_id"], :name => "game_line_id"

end
