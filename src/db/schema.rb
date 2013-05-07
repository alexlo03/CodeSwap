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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130506215107) do

  create_table "assignment_definition_to_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assignment_definition_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "assignment_definitions", :force => true do |t|
    t.integer  "assignment_id"
    t.string   "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "assignment_pairings", :force => true do |t|
    t.integer  "assignment_definition_id"
    t.integer  "seed"
    t.integer  "previous_id"
    t.integer  "depth"
    t.integer  "number_of_graders"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "assignments", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "start_date", :null => false
    t.datetime "end_date",   :null => false
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "hidden"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "course_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "group"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "course_number"
    t.integer  "section"
    t.string   "term"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "studentgroup_id"
    t.integer  "tagroup_id"
    t.integer  "user_id"
  end

  create_table "courses_users", :id => false, :force => true do |t|
    t.integer "course_id"
    t.integer "user_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "faculty_reviews", :force => true do |t|
    t.integer  "review_mapping_id"
    t.text     "content"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "file_submissions", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "assignment_definition_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "course_id"
    t.integer  "assignment_id"
    t.string   "file"
    t.integer  "uploaded_by"
  end

  create_table "question_extras", :force => true do |t|
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "review_question_id"
    t.string   "extra"
  end

  create_table "review_answers", :force => true do |t|
    t.text     "answer"
    t.integer  "user_id"
    t.integer  "review_question_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "other_id"
  end

  create_table "review_assignments", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "assignment_id"
    t.integer  "assignment_pairing_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "name"
    t.string   "description"
    t.boolean  "grouped"
  end

  create_table "review_mappings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "other_user_id"
    t.integer  "review_assignment_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "review_questions", :force => true do |t|
    t.text     "content"
    t.integer  "question_type"
    t.integer  "review_assignment_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "question_title"
  end

  create_table "student_in_courses", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "course_id"
  end

  create_table "ta_for_courses", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "course_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
