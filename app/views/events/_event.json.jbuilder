json.extract! event, :id, :title, :all_day, :start_date, :end_date, :created_at, :updated_at, :user_id
json.url event_url(event, format: :json)
