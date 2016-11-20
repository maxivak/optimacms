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

ActiveRecord::Schema.define(version: 20150610225422) do

  create_table "cms_languages", force: :cascade do |t|
    t.string  "title",     limit: 250
    t.string  "lang",      limit: 4
    t.boolean "enabled",   limit: 1,   default: true,              null: false
    t.string  "charset",   limit: 15,  default: "utf8_unicode_ci", null: false
    t.string  "locale",    limit: 255,                             null: false
    t.string  "lang_html", limit: 10,                              null: false
    t.integer "pos",       limit: 4,                               null: false
    t.string  "countries", limit: 255,                             null: false
  end

  add_index "cms_languages", ["lang"], name: "idxLang", unique: true, using: :btree

  create_table "cms_mediafiles", force: :cascade do |t|
    t.integer  "media_type",         limit: 4
    t.string   "path",               limit: 255
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
  end

  create_table "cms_pages", force: :cascade do |t|
    t.string   "title",             limit: 255,                 null: false
    t.string   "name",              limit: 255
    t.string   "url",               limit: 255
    t.integer  "url_parts_count",   limit: 1,   default: 0,     null: false
    t.integer  "url_vars_count",    limit: 1,   default: 0,     null: false
    t.string   "parsed_url",        limit: 255
    t.integer  "parent_id",         limit: 4,   default: 0,     null: false
    t.string   "view_path",         limit: 255
    t.boolean  "is_translated",     limit: 1,   default: false, null: false
    t.integer  "status",            limit: 4,   default: 0,     null: false
    t.integer  "pos",               limit: 4,   default: 0,     null: false
    t.string   "redir_url",         limit: 255
    t.integer  "template_id",       limit: 4
    t.integer  "layout_id",         limit: 4
    t.integer  "owner",             limit: 4
    t.boolean  "is_folder",         limit: 1,   default: false, null: false
    t.string   "controller_action", limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "enabled",           limit: 1,   default: 1,     null: false
  end

  add_index "cms_pages", ["name"], name: "index_cms_pages_on_name", using: :btree
  add_index "cms_pages", ["parent_id"], name: "parent_id", using: :btree
  add_index "cms_pages", ["status"], name: "status", using: :btree
  add_index "cms_pages", ["url"], name: "url", using: :btree

  create_table "cms_pages_translation", force: :cascade do |t|
    t.integer "item_id",           limit: 4,     default: 0, null: false
    t.integer "page_id",           limit: 4
    t.string  "lang",              limit: 5,                 null: false
    t.string  "meta_title",        limit: 255
    t.text    "meta_description",  limit: 65535
    t.string  "meta_keywords",     limit: 255
    t.string  "template_filename", limit: 255
  end

  add_index "cms_pages_translation", ["item_id"], name: "item_id", using: :btree
  add_index "cms_pages_translation", ["lang"], name: "lang", using: :btree
  add_index "cms_pages_translation", ["template_filename"], name: "template", using: :btree

  create_table "cms_templates", force: :cascade do |t|
    t.string   "title",         limit: 255,                 null: false
    t.string   "name",          limit: 255
    t.string   "basename",      limit: 255,                 null: false
    t.string   "basepath",      limit: 255,                 null: false
    t.string   "basedirpath",   limit: 255,                 null: false
    t.integer  "type_id",       limit: 1
    t.string   "tpl_format",    limit: 255
    t.integer  "pos",           limit: 4
    t.boolean  "is_translated", limit: 1,   default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "is_folder",     limit: 1,   default: false, null: false
    t.boolean  "enabled",       limit: 1,   default: true,  null: false
    t.string   "ancestry",      limit: 255
  end

  add_index "cms_templates", ["ancestry"], name: "ancestry", using: :btree
  add_index "cms_templates", ["basepath"], name: "basepath", using: :btree
  add_index "cms_templates", ["pos"], name: "pos", using: :btree

  create_table "cms_templates_translation", force: :cascade do |t|
    t.integer "item_id", limit: 4, null: false
    t.string  "lang",    limit: 5, null: false
  end

  add_index "cms_templates_translation", ["item_id", "lang"], name: "item_id", unique: true, using: :btree

  create_table "cms_templatetypes", force: :cascade do |t|
    t.string  "name",  limit: 255
    t.string  "title", limit: 255
    t.integer "pos",   limit: 4,   null: false
  end

  create_table "cms_users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cms_users", ["email"], name: "index_optimacms_cms_users_on_email", unique: true, using: :btree
  add_index "cms_users", ["reset_password_token"], name: "index_optimacms_cms_users_on_reset_password_token", unique: true, using: :btree

  create_table "news", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "optimacms_articles", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "text",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
