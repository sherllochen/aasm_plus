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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_07_144216) do

  create_table "aasm_plus_state_chains", force: :cascade do |t|
    t.integer "user_id"
    t.string "from"
    t.string "to"
    t.string "event"
    t.datetime "assign_time"
    t.string "stateable_type"
    t.integer "stateable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assign_time"], name: "index_aasm_plus_state_chains_on_assign_time"
    t.index ["event"], name: "index_aasm_plus_state_chains_on_event"
    t.index ["from"], name: "index_aasm_plus_state_chains_on_from"
    t.index ["stateable_id"], name: "index_aasm_plus_state_chains_on_stateable_id"
    t.index ["stateable_type"], name: "index_aasm_plus_state_chains_on_stateable_type"
    t.index ["to"], name: "index_aasm_plus_state_chains_on_to"
    t.index ["user_id"], name: "index_aasm_plus_state_chains_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "no"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
