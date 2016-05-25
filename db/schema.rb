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


ActiveRecord::Schema.define(version: 20160125072740) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "comment_valuations", force: :cascade do |t|
    t.boolean  "like",       limit: 1, default: false
    t.integer  "user_id",    limit: 4
    t.integer  "comment_id", limit: 4
    t.integer  "lecture_id", limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "comment_valuations", ["comment_id", "user_id"], name: "index_comment_valuations_on_comment_id_and_user_id", using: :btree
  add_index "comment_valuations", ["comment_id"], name: "index_comment_valuations_on_comment_id", using: :btree
  add_index "comment_valuations", ["lecture_id"], name: "index_comment_valuations_on_lecture_id", using: :btree
  add_index "comment_valuations", ["user_id"], name: "index_comment_valuations_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "user_id",    limit: 4
    t.integer  "lecture_id", limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "likedcount", limit: 4,     default: 0
  end

  add_index "comments", ["lecture_id"], name: "index_comments_on_lecture_id", using: :btree
  add_index "comments", ["user_id", "created_at"], name: "index_comments_on_user_id_and_created_at", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "enrollments", force: :cascade do |t|
    t.string   "day",          limit: 255
    t.string   "begin_time",   limit: 255
    t.string   "end_time",     limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "lecture_id",   limit: 4
    t.integer  "user_id",      limit: 4
    t.string   "days",         limit: 255
    t.integer  "timetable_id", limit: 4
  end

  add_index "enrollments", ["timetable_id"], name: "index_enrollments_on_timetable_id", using: :btree

  create_table "lectures", force: :cascade do |t|
    t.string   "subject",         limit: 255
    t.string   "professor",       limit: 255
    t.string   "major",           limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "lecturetime",     limit: 255
    t.float    "acc_grade",       limit: 24,  default: 0.0
    t.float    "acc_workload",    limit: 24,  default: 0.0
    t.float    "acc_level",       limit: 24,  default: 0.0
    t.float    "acc_achievement", limit: 24,  default: 0.0
    t.float    "acc_homework",    limit: 24,  default: 0.0
    t.float    "acc_total",       limit: 24,  default: 0.0
    t.string   "place",           limit: 255
    t.string   "isu",             limit: 255
    t.string   "semester",        limit: 255
    t.float    "credit",          limit: 24
    t.string   "open_department", limit: 255
  end

  create_table "plural_attrs", force: :cascade do |t|
    t.string   "lectureTime", limit: 255
    t.string   "place",       limit: 255
    t.integer  "lecture_id",  limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "timetables", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "semester",   limit: 255, default: "1학기"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",        limit: 255
    t.string   "uid",             limit: 255
    t.string   "name",            limit: 255
    t.string   "image",           limit: 255
    t.string   "token",           limit: 255
    t.datetime "expires_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "nickname",        limit: 255
    t.boolean  "admin",           limit: 1,   default: false
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.integer  "year",            limit: 4
    t.string   "major",           limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "valuations", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "lecture_id",  limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "up",          limit: 4,     default: 0
    t.integer  "down",        limit: 4,     default: 0
    t.integer  "grade",       limit: 4
    t.integer  "workload",    limit: 4
    t.integer  "level",       limit: 4
    t.integer  "achievement", limit: 4
    t.integer  "homework",    limit: 4
    t.integer  "total",       limit: 4
    t.text     "content",     limit: 65535
  end

end
