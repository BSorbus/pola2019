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

ActiveRecord::Schema.define(version: 2020_02_20_220621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"

  create_table "accessorizations", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "user_id"], name: "index_accessorizations_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_accessorizations_on_event_id"
    t.index ["role_id"], name: "index_accessorizations_on_role_id"
    t.index ["user_id", "event_id"], name: "index_accessorizations_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_accessorizations_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "attachmenable_type"
    t.bigint "attachmenable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note", default: ""
    t.bigint "user_id"
    t.index ["attachmenable_type", "attachmenable_id"], name: "index_attachments_on_attachmenable_type_and_attachmenable_id"
    t.index ["user_id"], name: "index_attachments_on_user_id"
  end

  create_table "business_trip_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.integer "step", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_business_trip_statuses_on_name", unique: true
    t.index ["step"], name: "index_business_trip_statuses_on_step", unique: true
  end

  create_table "business_trips", force: :cascade do |t|
    t.string "number"
    t.bigint "employee_id"
    t.date "start_date"
    t.date "end_date"
    t.string "destination"
    t.text "purpose", default: ""
    t.text "trip_confirmation", default: ""
    t.decimal "payment_on_account", precision: 8, scale: 2, default: "0.0"
    t.bigint "payment_on_account_approved_id"
    t.datetime "payment_on_account_approved_date_time"
    t.text "note", default: ""
    t.bigint "business_trip_status_id", default: 1
    t.bigint "business_trip_status_updated_user_id"
    t.datetime "business_trip_status_updated_at"
    t.bigint "user_id"
    t.integer "hotel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_trip_status_id"], name: "index_business_trips_on_business_trip_status_id"
    t.index ["business_trip_status_updated_user_id"], name: "index_business_trips_on_business_trip_status_updated_user_id"
    t.index ["employee_id"], name: "index_business_trips_on_employee_id"
    t.index ["payment_on_account_approved_id"], name: "index_business_trips_on_payment_on_account_approved_id"
    t.index ["user_id"], name: "index_business_trips_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_comments_on_event_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "correspondences", force: :cascade do |t|
    t.string "correspondenable_type"
    t.bigint "correspondenable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["correspondenable_type", "correspondenable_id"], name: "index_correspondences_on_correspondenable_type_and_id"
    t.index ["user_id"], name: "index_correspondences_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nip"
    t.string "regon"
    t.string "address_city"
    t.string "address_street"
    t.string "address_house"
    t.string "address_number"
    t.string "address_postal_code"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.string "epuap"
    t.string "rpt"
    t.bigint "user_id"
    t.integer "attachments_count", default: 0, null: false
    t.index ["name"], name: "index_customers_on_name"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "reference_id"
    t.string "reference_type"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "documentations", force: :cascade do |t|
    t.string "documentationable_type"
    t.bigint "documentationable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["documentationable_type", "documentationable_id"], name: "index_documentations_on_documentationable_type_and_id"
    t.index ["user_id"], name: "index_documentations_on_user_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.string "name"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attachments_count", default: 0, null: false
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "errand_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "errands", force: :cascade do |t|
    t.string "number"
    t.string "principal"
    t.bigint "errand_status_id"
    t.date "order_date"
    t.date "adoption_date"
    t.date "start_date"
    t.date "end_date"
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "attachments_count", default: 0, null: false
    t.index ["adoption_date"], name: "index_errands_on_adoption_date"
    t.index ["end_date"], name: "index_errands_on_end_date"
    t.index ["errand_status_id"], name: "index_errands_on_errand_status_id"
    t.index ["number"], name: "index_errands_on_number"
    t.index ["order_date"], name: "index_errands_on_order_date"
    t.index ["principal"], name: "index_errands_on_principal"
    t.index ["start_date"], name: "index_errands_on_start_date"
    t.index ["user_id"], name: "index_errands_on_user_id"
  end

  create_table "event_effects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_event_effects_on_name"
  end

  create_table "event_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_event_statuses_on_name"
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.string "activities", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_event_types_on_name"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.boolean "all_day"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "project_id"
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_status_id", default: 1
    t.bigint "event_type_id"
    t.bigint "errand_id"
    t.bigint "user_id"
    t.bigint "event_effect_id"
    t.integer "attachments_count", default: 0, null: false
    t.index ["end_date"], name: "index_events_on_end_date"
    t.index ["errand_id"], name: "index_events_on_errand_id"
    t.index ["event_effect_id"], name: "index_events_on_event_effect_id"
    t.index ["event_status_id"], name: "index_events_on_event_status_id"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["project_id"], name: "index_events_on_project_id"
    t.index ["start_date"], name: "index_events_on_start_date"
    t.index ["title"], name: "index_events_on_title"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "flows", force: :cascade do |t|
    t.bigint "business_trip_id"
    t.bigint "business_trip_status_id"
    t.bigint "business_trip_status_updated_user_id"
    t.datetime "business_trip_status_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_trip_id"], name: "index_flows_on_business_trip_id"
    t.index ["business_trip_status_id"], name: "index_flows_on_business_trip_status_id"
    t.index ["business_trip_status_updated_at"], name: "index_flows_on_business_trip_status_updated_at"
    t.index ["business_trip_status_updated_user_id"], name: "index_flows_on_business_trip_status_updated_user_id"
  end

  create_table "infos", force: :cascade do |t|
    t.string "infoable_type"
    t.bigint "infoable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["infoable_type", "infoable_id"], name: "index_infos_on_infoable_type_and_infoable_id"
    t.index ["user_id"], name: "index_infos_on_user_id"
  end

  create_table "inspection_protocols", force: :cascade do |t|
    t.string "inspectionable_type"
    t.bigint "inspectionable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inspectionable_type", "inspectionable_id"], name: "index_inspection_protocols_on_inspectionable_type_and_id"
    t.index ["user_id"], name: "index_inspection_protocols_on_user_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.string "measurementable_type"
    t.bigint "measurementable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measurementable_type", "measurementable_id"], name: "index_measurements_on_measurementable_type_and_id"
    t.index ["user_id"], name: "index_measurements_on_user_id"
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_salt"
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.datetime "created_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "opinions", force: :cascade do |t|
    t.string "opinionable_type"
    t.bigint "opinionable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opinionable_type", "opinionable_id"], name: "index_opinions_on_opinionable_type_and_opinionable_id"
    t.index ["user_id"], name: "index_opinions_on_user_id"
  end

  create_table "original_documentations", force: :cascade do |t|
    t.string "original_documentionable_type"
    t.bigint "original_documentionable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["original_documentionable_type", "original_documentionable_id"], name: "index_original_documentations_on_type_and_id"
    t.index ["user_id"], name: "index_original_documentations_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "photoable_type"
    t.bigint "photoable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.float "latitude"
    t.float "longitude"
    t.datetime "photo_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude"], name: "index_photos_on_latitude"
    t.index ["longitude"], name: "index_photos_on_longitude"
    t.index ["photo_created_at"], name: "index_photos_on_photo_created_at"
    t.index ["photoable_type", "photoable_id"], name: "index_photos_on_photoable_type_and_photoable_id"
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "point_files", force: :cascade do |t|
    t.bigint "project_id"
    t.datetime "load_date"
    t.string "load_file"
    t.integer "status"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "oi_2", limit: 16
    t.string "oi_3", limit: 255
    t.string "oi_4", limit: 100
    t.integer "oi_5"
    t.integer "oi_6"
    t.integer "oi_7"
    t.integer "oi_8"
    t.integer "oi_9"
    t.integer "oi_10"
    t.string "dp_2", limit: 250
    t.string "dp_3", limit: 13
    t.string "dp_4", limit: 10
    t.string "dp_5", limit: 100
    t.string "dp_6", limit: 250
    t.string "dp_7", limit: 50
    t.string "dp_8", limit: 6
    t.integer "ws_2"
    t.integer "ws_3"
    t.integer "ws_4"
    t.integer "ws_5"
    t.integer "ws_6"
    t.integer "ws_7"
    t.index ["load_date"], name: "index_point_files_on_load_date"
    t.index ["project_id"], name: "index_point_files_on_project_id"
    t.index ["status"], name: "index_point_files_on_status"
  end

  create_table "project_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_project_statuses_on_name"
  end

  create_table "projects", force: :cascade do |t|
    t.string "number"
    t.date "registration"
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_status_id", default: 1
    t.bigint "customer_id"
    t.bigint "user_id"
    t.bigint "enrollment_id"
    t.integer "attachments_count", default: 0, null: false
    t.string "area_id"
    t.string "area_name"
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["enrollment_id"], name: "index_projects_on_enrollment_id"
    t.index ["number"], name: "index_projects_on_number"
    t.index ["project_status_id"], name: "index_projects_on_project_status_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "proposal_files", force: :cascade do |t|
    t.bigint "project_id"
    t.datetime "load_date"
    t.string "load_file"
    t.integer "status"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nabor_id"
    t.string "nabor_opis"
    t.string "rodzaj_id"
    t.string "rodzaj_opis"
    t.index ["load_date"], name: "index_proposal_files_on_load_date"
    t.index ["project_id"], name: "index_proposal_files_on_project_id"
    t.index ["status"], name: "index_proposal_files_on_status"
  end

  create_table "protocols", force: :cascade do |t|
    t.string "protocolable_type"
    t.bigint "protocolable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["protocolable_type", "protocolable_id"], name: "index_protocols_on_protocolable_type_and_protocolable_id"
    t.index ["user_id"], name: "index_protocols_on_user_id"
  end

  create_table "roads", force: :cascade do |t|
    t.bigint "business_trip_id"
    t.string "from"
    t.datetime "start_date_time"
    t.string "to"
    t.datetime "end_date_time"
    t.bigint "transport_type_id"
    t.decimal "cost", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_trip_id"], name: "index_roads_on_business_trip_id"
    t.index ["transport_type_id"], name: "index_roads_on_transport_type_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.boolean "special", default: false, null: false
    t.string "activities", default: [], array: true
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["special"], name: "index_roles_on_special"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", unique: true
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "statements", force: :cascade do |t|
    t.string "statemenable_type"
    t.bigint "statemenable_id"
    t.string "attached_file"
    t.string "file_content_type"
    t.string "file_size"
    t.text "note", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statemenable_type", "statemenable_id"], name: "index_statements_on_statemenable_type_and_statemenable_id"
    t.index ["user_id"], name: "index_statements_on_user_id"
  end

  create_table "transport_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transports", force: :cascade do |t|
    t.bigint "business_trip_id"
    t.bigint "transport_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_trip_id"], name: "index_transports_on_business_trip_id"
    t.index ["transport_type_id"], name: "index_transports_on_transport_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.text "note", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "legitimation"
    t.string "position"
    t.datetime "last_activity_at"
    t.datetime "expired_at"
    t.datetime "password_changed_at"
    t.integer "attachments_count", default: 0, null: false
    t.boolean "notification_by_email", default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "works", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "trackable_url"
    t.bigint "user_id"
    t.string "action"
    t.text "parameters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trackable_type", "trackable_id"], name: "index_works_on_trackable_type_and_trackable_id"
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  create_table "ww_points", force: :cascade do |t|
    t.bigint "point_file_id"
    t.string "ww_2", limit: 10
    t.string "ww_3", limit: 100
    t.string "ww_4", limit: 100
    t.string "ww_5", limit: 100
    t.string "ww_6", limit: 100
    t.string "ww_7", limit: 7
    t.string "ww_8", limit: 100
    t.string "ww_9", limit: 7
    t.string "ww_10", limit: 250
    t.string "ww_11", limit: 5
    t.string "ww_12", limit: 50
    t.string "ww_13", limit: 6
    t.decimal "ww_14", precision: 7, scale: 4
    t.decimal "ww_15", precision: 7, scale: 4
    t.string "ww_16", limit: 100
    t.index ["point_file_id"], name: "index_ww_points_on_point_file_id"
    t.index ["ww_10"], name: "index_ww_points_on_ww_10"
    t.index ["ww_11"], name: "index_ww_points_on_ww_11"
    t.index ["ww_12"], name: "index_ww_points_on_ww_12"
    t.index ["ww_13"], name: "index_ww_points_on_ww_13"
    t.index ["ww_14"], name: "index_ww_points_on_ww_14"
    t.index ["ww_15"], name: "index_ww_points_on_ww_15"
    t.index ["ww_16"], name: "index_ww_points_on_ww_16"
    t.index ["ww_2"], name: "index_ww_points_on_ww_2"
    t.index ["ww_3"], name: "index_ww_points_on_ww_3"
    t.index ["ww_4"], name: "index_ww_points_on_ww_4"
    t.index ["ww_5"], name: "index_ww_points_on_ww_5"
    t.index ["ww_6"], name: "index_ww_points_on_ww_6"
    t.index ["ww_7"], name: "index_ww_points_on_ww_7"
    t.index ["ww_8"], name: "index_ww_points_on_ww_8"
    t.index ["ww_9"], name: "index_ww_points_on_ww_9"
  end

  create_table "xml_kamien_milowy_tables", force: :cascade do |t|
    t.bigint "xml_zadanie_table_id"
    t.string "nazwa"
    t.boolean "czy_oznacza_zakonczenie"
    t.string "planowana_data_zakonczenia"
    t.string "data_punktu_krytycznego"
    t.string "data_punktu_ostatecznego"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["xml_zadanie_table_id"], name: "index_xml_kamien_milowy_tables_on_xml_zadanie_table_id"
  end

  create_table "xml_miejsce_realizacji_tables", force: :cascade do |t|
    t.bigint "xml_partner_table_id"
    t.string "wojewodztwo_id"
    t.string "wojewodztwo_opis"
    t.boolean "czy_na_terenie_calego_wojewodztwa"
    t.string "powiat_id"
    t.string "powiat_opis"
    t.boolean "czy_na_terenie_calego_powiatu"
    t.string "gmina_id"
    t.string "gmina_opis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["xml_partner_table_id"], name: "index_xml_miejsce_realizacji_tables_on_xml_partner_table_id"
  end

  create_table "xml_partner_tables", force: :cascade do |t|
    t.bigint "proposal_file_id"
    t.string "dp_nazwa"
    t.string "dp_nip"
    t.string "dp_regon"
    t.string "dp_as_miejscowosc_id"
    t.string "dp_as_miejscowosc_opis"
    t.string "dp_as_kod_pocztowy"
    t.string "dp_as_ulica_id"
    t.string "dp_as_ulica_opis"
    t.string "dp_as_nr"
    t.string "dp_as_lokal"
    t.string "dp_as_telefon"
    t.string "dp_as_faks"
    t.string "dp_as_email"
    t.string "dp_as_epuap"
    t.string "numer_wpisu_uke"
    t.string "mrp_obszar_realizacji_id"
    t.string "mrp_obszar_realizacji_opis"
    t.integer "mrp_maksymalna_kwota_dofinansowania"
    t.decimal "mrp_maksymalna_intensywnosc_wsparcia", precision: 6, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_file_id"], name: "index_xml_partner_tables_on_proposal_file_id"
  end

  create_table "xml_projekt_tables", force: :cascade do |t|
    t.bigint "proposal_file_id"
    t.string "do_tytul"
    t.date "do_okres_realizacji_data_od"
    t.date "do_okres_realizacji_data_do"
    t.date "do_okres_kwalifikowalnosci_wydatkow_data_od"
    t.date "do_okres_kwalifikowalnosci_wydatkow_data_do"
    t.decimal "mfp_mfo_mf_wydatki_ogolem", precision: 15, scale: 2
    t.decimal "mfp_mfo_mf_wydatki_kwalifikowane", precision: 15, scale: 2
    t.decimal "mfp_mfo_mf_dofinansowanie", precision: 15, scale: 2
    t.decimal "mfp_mfo_mf_procent_dofinansowania", precision: 6, scale: 2
    t.decimal "mfp_mfo_mf_wklad_ue", precision: 15, scale: 2
    t.decimal "mfp_mfo_mf_procent_dofinansowanie_ue", precision: 6, scale: 2
    t.decimal "mfp_mfo_mf_wklad_wlasny", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_file_id"], name: "index_xml_projekt_tables_on_proposal_file_id"
  end

  create_table "xml_wskaznik_tables", force: :cascade do |t|
    t.bigint "xml_projekt_table_id"
    t.integer "numer"
    t.string "nazwa_id"
    t.string "nazwa_kod"
    t.string "nazwa_opis"
    t.string "typ"
    t.string "jednostka_miary_opis"
    t.string "wartosc_bazowa"
    t.string "wartosc_docelowa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["xml_projekt_table_id"], name: "index_xml_wskaznik_tables_on_xml_projekt_table_id"
  end

  create_table "xml_wybrana_technologia_tables", force: :cascade do |t|
    t.bigint "xml_projekt_table_id"
    t.string "element_id"
    t.string "element_opis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["xml_projekt_table_id"], name: "index_xml_wybrana_technologia_tables_on_xml_projekt_table_id"
  end

  create_table "xml_zadanie_tables", force: :cascade do |t|
    t.bigint "xml_projekt_table_id"
    t.string "zadanie"
    t.string "numer_zadania"
    t.string "nazwa"
    t.string "idkm_data_rozpoczecia"
    t.string "idkm_planowana_data_zakonczenia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["xml_projekt_table_id"], name: "index_xml_zadanie_tables_on_xml_projekt_table_id"
  end

  create_table "zs_points", force: :cascade do |t|
    t.bigint "point_file_id"
    t.string "zs_2", limit: 10
    t.string "zs_3", limit: 100
    t.string "zs_4", limit: 100
    t.string "zs_5", limit: 100
    t.string "zs_6", limit: 100
    t.string "zs_7", limit: 7
    t.string "zs_8", limit: 100
    t.string "zs_9", limit: 7
    t.string "zs_10", limit: 250
    t.string "zs_11", limit: 5
    t.string "zs_12", limit: 50
    t.decimal "zs_13", precision: 7, scale: 4
    t.decimal "zs_14", precision: 7, scale: 4
    t.string "zs_15", limit: 100
    t.integer "zs_16"
    t.integer "zs_17"
    t.string "zs_18", limit: 100
    t.integer "zs_19"
    t.integer "zs_20"
    t.integer "zs_21"
    t.index ["point_file_id"], name: "index_zs_points_on_point_file_id"
    t.index ["zs_10"], name: "index_zs_points_on_zs_10"
    t.index ["zs_11"], name: "index_zs_points_on_zs_11"
    t.index ["zs_12"], name: "index_zs_points_on_zs_12"
    t.index ["zs_13"], name: "index_zs_points_on_zs_13"
    t.index ["zs_14"], name: "index_zs_points_on_zs_14"
    t.index ["zs_15"], name: "index_zs_points_on_zs_15"
    t.index ["zs_16"], name: "index_zs_points_on_zs_16"
    t.index ["zs_17"], name: "index_zs_points_on_zs_17"
    t.index ["zs_18"], name: "index_zs_points_on_zs_18"
    t.index ["zs_19"], name: "index_zs_points_on_zs_19"
    t.index ["zs_2"], name: "index_zs_points_on_zs_2"
    t.index ["zs_20"], name: "index_zs_points_on_zs_20"
    t.index ["zs_21"], name: "index_zs_points_on_zs_21"
    t.index ["zs_3"], name: "index_zs_points_on_zs_3"
    t.index ["zs_4"], name: "index_zs_points_on_zs_4"
    t.index ["zs_5"], name: "index_zs_points_on_zs_5"
    t.index ["zs_6"], name: "index_zs_points_on_zs_6"
    t.index ["zs_7"], name: "index_zs_points_on_zs_7"
    t.index ["zs_8"], name: "index_zs_points_on_zs_8"
    t.index ["zs_9"], name: "index_zs_points_on_zs_9"
  end

  add_foreign_key "attachments", "users"
  add_foreign_key "business_trips", "business_trip_statuses"
  add_foreign_key "business_trips", "users"
  add_foreign_key "business_trips", "users", column: "business_trip_status_updated_user_id"
  add_foreign_key "business_trips", "users", column: "employee_id"
  add_foreign_key "comments", "events"
  add_foreign_key "comments", "users"
  add_foreign_key "correspondences", "users"
  add_foreign_key "customers", "users"
  add_foreign_key "documentations", "users"
  add_foreign_key "enrollments", "users"
  add_foreign_key "errands", "errand_statuses"
  add_foreign_key "errands", "users"
  add_foreign_key "events", "errands"
  add_foreign_key "events", "event_statuses"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "users"
  add_foreign_key "flows", "business_trip_statuses"
  add_foreign_key "flows", "business_trips"
  add_foreign_key "flows", "users", column: "business_trip_status_updated_user_id"
  add_foreign_key "infos", "users"
  add_foreign_key "inspection_protocols", "users"
  add_foreign_key "measurements", "users"
  add_foreign_key "opinions", "users"
  add_foreign_key "original_documentations", "users"
  add_foreign_key "photos", "users"
  add_foreign_key "point_files", "projects"
  add_foreign_key "projects", "customers"
  add_foreign_key "projects", "enrollments"
  add_foreign_key "projects", "project_statuses"
  add_foreign_key "projects", "users"
  add_foreign_key "proposal_files", "projects"
  add_foreign_key "protocols", "users"
  add_foreign_key "roads", "business_trips"
  add_foreign_key "roads", "transport_types"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "statements", "users"
  add_foreign_key "transports", "business_trips"
  add_foreign_key "transports", "transport_types"
  add_foreign_key "ww_points", "point_files"
  add_foreign_key "xml_kamien_milowy_tables", "xml_zadanie_tables"
  add_foreign_key "xml_miejsce_realizacji_tables", "xml_partner_tables"
  add_foreign_key "xml_partner_tables", "proposal_files"
  add_foreign_key "xml_projekt_tables", "proposal_files"
  add_foreign_key "xml_wskaznik_tables", "xml_projekt_tables"
  add_foreign_key "xml_wybrana_technologia_tables", "xml_projekt_tables"
  add_foreign_key "xml_zadanie_tables", "xml_projekt_tables"
  add_foreign_key "zs_points", "point_files"
end
