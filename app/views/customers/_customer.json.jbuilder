json.extract! customer, :id, :name, :fullname, :created_at, :updated_at
json.url customer_url(customer, format: :json)
