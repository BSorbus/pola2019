json.extract! business_trip, :id, :number, :purpose, :start, :end, :destination, :note, :user_id, :created_at, :updated_at
json.url business_trip_url(business_trip, format: :json)
