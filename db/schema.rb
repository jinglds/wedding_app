# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141208143459) do

  create_table "articles", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content",    limit: 255
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",              default: false
  end

  add_index "articles", ["published", "category"], name: "index_articles_on_published_and_category"
  add_index "articles", ["user_id"], name: "index_articles_on_user_id"

  create_table "checklists", force: true do |t|
    t.integer  "event_id"
    t.boolean  "completed",  default: false
    t.string   "title"
    t.integer  "time_range"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborations", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.boolean  "accepted",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collaborations", ["user_id", "event_id"], name: "index_collaborations_on_user_id_and_event_id"

  create_table "comments", force: true do |t|
    t.string   "title"
    t.integer  "shop_id"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cached_votes_total",      default: 0
    t.integer  "cached_votes_score",      default: 0
    t.integer  "cached_votes_up",         default: 0
    t.integer  "cached_votes_down",       default: 0
    t.integer  "cached_weighted_score",   default: 0
    t.integer  "cached_weighted_total",   default: 0
    t.float    "cached_weighted_average", default: 0.0
  end

  add_index "comments", ["cached_votes_down"], name: "index_comments_on_cached_votes_down"
  add_index "comments", ["cached_votes_score"], name: "index_comments_on_cached_votes_score"
  add_index "comments", ["cached_votes_total"], name: "index_comments_on_cached_votes_total"
  add_index "comments", ["cached_votes_up"], name: "index_comments_on_cached_votes_up"
  add_index "comments", ["cached_weighted_average"], name: "index_comments_on_cached_weighted_average"
  add_index "comments", ["cached_weighted_score"], name: "index_comments_on_cached_weighted_score"
  add_index "comments", ["cached_weighted_total"], name: "index_comments_on_cached_weighted_total"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "event_vendors", force: true do |t|
    t.integer  "event_id"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_vendors", ["event_id", "vendor_id"], name: "index_event_vendors_on_event_id_and_vendor_id"

  create_table "events", force: true do |t|
    t.integer  "user_id"
    t.string   "event_type"
    t.string   "name"
    t.float    "budget"
    t.string   "bride_name"
    t.string   "groom_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.datetime "time"
    t.integer  "guest_amt"
    t.string   "invitation_card"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "expenses", force: true do |t|
    t.integer  "event_id"
    t.integer  "vendor_id"
    t.float    "amount"
    t.string   "expense_type"
    t.string   "receiver"
    t.string   "title"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "paid",         default: false
  end

  add_index "expenses", ["event_id", "created_at"], name: "index_expenses_on_event_id_and_created_at"
  add_index "expenses", ["event_id"], name: "index_expenses_on_event_id"

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "favorited_id"
    t.string   "favorited_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favorited_id", "favorited_type"], name: "index_favorites_on_favorited_id_and_favorited_type"
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "guests", force: true do |t|
    t.integer  "event_id"
    t.string   "side"
    t.string   "name"
    t.string   "prefix"
    t.integer  "adults"
    t.integer  "children"
    t.string   "phone"
    t.text     "address",         limit: 255
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "group",                       default: "none"
    t.integer  "table_no"
    t.string   "note"
    t.boolean  "attending",                   default: false
    t.boolean  "invitation_sent",             default: false
    t.string   "invited_via"
    t.boolean  "responded",                   default: false
  end

  add_index "guests", ["event_id"], name: "index_guests_on_event_id"
  add_index "guests", ["group", "event_id"], name: "index_guests_on_group_and_event_id"
  add_index "guests", ["side", "event_id"], name: "index_guests_on_side_and_event_id"
  add_index "guests", ["user_id"], name: "index_guests_on_user_id"

  create_table "photos", force: true do |t|
    t.string   "image_uid"
    t.string   "title"
    t.string   "shop_id"
    t.boolean  "cover",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["shop_id"], name: "index_photos_on_shop_id"

  create_table "pictures", force: true do |t|
    t.string   "image_uid"
    t.string   "title"
    t.integer  "event_id"
    t.boolean  "cover",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shop_tags", force: true do |t|
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", force: true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "name"
    t.string   "price_range"
    t.text     "description",             limit: 255
    t.string   "phone"
    t.string   "email"
    t.text     "address",                 limit: 255
    t.string   "website"
    t.text     "details",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover_url",                           default: "default.png"
    t.integer  "cached_votes_total",                  default: 0
    t.integer  "cached_votes_score",                  default: 0
    t.integer  "cached_votes_up",                     default: 0
    t.integer  "cached_votes_down",                   default: 0
    t.integer  "cached_weighted_score",               default: 0
    t.integer  "cached_weighted_total",               default: 0
    t.float    "cached_weighted_average",             default: 0.0
    t.boolean  "approval",                            default: true
    t.string   "attachment_uid"
  end

  add_index "shops", ["cached_votes_down"], name: "index_shops_on_cached_votes_down"
  add_index "shops", ["cached_votes_score"], name: "index_shops_on_cached_votes_score"
  add_index "shops", ["cached_votes_total"], name: "index_shops_on_cached_votes_total"
  add_index "shops", ["cached_votes_up"], name: "index_shops_on_cached_votes_up"
  add_index "shops", ["cached_weighted_average"], name: "index_shops_on_cached_weighted_average"
  add_index "shops", ["cached_weighted_score"], name: "index_shops_on_cached_weighted_score"
  add_index "shops", ["cached_weighted_total"], name: "index_shops_on_cached_weighted_total"
  add_index "shops", ["user_id", "created_at"], name: "index_shops_on_user_id_and_created_at"
  add_index "shops", ["user_id"], name: "index_shops_on_user_id"

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["tag_id", "taggable_id"], name: "index_taggings_on_tag_id_and_taggable_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "tasks", force: true do |t|
    t.string   "title"
    t.datetime "due_date"
    t.boolean  "completed",  default: false
    t.boolean  "redo",       default: false
    t.datetime "reminder"
    t.boolean  "optional",   default: false
    t.integer  "importance", default: 2
    t.string   "note"
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "rank",       default: 0
    t.integer  "vendor_id"
  end

  add_index "tasks", ["ancestry"], name: "index_tasks_on_ancestry"
  add_index "tasks", ["event_id"], name: "index_tasks_on_event_id"
  add_index "tasks", ["vendor_id"], name: "index_tasks_on_vendor_id"

  create_table "users", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.text     "address",                limit: 255
    t.string   "phone"
    t.string   "role",                               default: "client"
    t.string   "email",                              default: "",       null: false
    t.string   "encrypted_password",                 default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approval",                           default: false
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["role"], name: "index_users_on_role"

  create_table "vendors", force: true do |t|
    t.integer  "task_id"
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
    t.string   "note"
    t.integer  "event_id"
    t.integer  "user_id"
  end

  add_index "vendors", ["event_id"], name: "index_vendors_on_event_id"
  add_index "vendors", ["shop_id"], name: "index_vendors_on_shop_id"
  add_index "vendors", ["task_id"], name: "index_vendors_on_task_id"
  add_index "vendors", ["user_id"], name: "index_vendors_on_user_id"

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id"], name: "index_votes_on_votable_id"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id"], name: "index_votes_on_voter_id"

end
