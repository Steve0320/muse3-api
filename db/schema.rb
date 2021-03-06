# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_15_051825) do

  create_table "media_files", force: :cascade do |t|
    t.integer "media_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "search_data"
    t.string "file_path"
    t.string "name", null: false
    t.index ["media_group_id"], name: "index_media_files_on_media_group_id"
  end

  create_table "media_groups", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.string "description"
    t.string "poster_url"
    t.integer "rating"
    t.string "from_searcher", null: false
    t.string "searcher_key", null: false
    t.string "search_data"
  end

end
