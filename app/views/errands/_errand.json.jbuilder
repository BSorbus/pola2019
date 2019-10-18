json.extract! errand, :id, :number, :principal, :errand_status_id, :order_date, :adoption_date, :start_date, :end_date, :note, :created_at, :updated_at, :fullname
json.url errand_url(errand, format: :json)
