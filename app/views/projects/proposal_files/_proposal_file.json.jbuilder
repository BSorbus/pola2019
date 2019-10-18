json.extract! proposal_file, :id, :project_id, :load_date, :load_file, :status, :note, :created_at, :updated_at
json.url proposal_file_url(proposal_file, format: :json)
