CarrierWave.configure do |config|
  # config.root = Rails.application.secrets[:carrierwave_store_dir]
  config.enable_processing = true
  
  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false
end
