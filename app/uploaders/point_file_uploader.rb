class PointFileUploader < CarrierWave::Uploader::Base

  storage :file

  ###########################################################################
  # LOGGING — minimalne, bezpieczne, nieinwazyjne
  ###########################################################################

  def log(msg)
    Rails.logger.info "[PointFileUploader] #{msg}"
  end

  ###########################################################################
  # STORE DIR / CACHE DIR — identyczne jak w Twojej wersji
  ###########################################################################

  def store_dir
    "#{Rails.application.secrets[:carrierwave_store_dir]}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    Rails.application.secrets[:carrierwave_cache_dir]
  end

  ###########################################################################
  # EXTENSION WHITELIST — identyczne jak w Twojej wersji
  ###########################################################################

  def extension_whitelist
    log "extension_whitelist: allowed csv"
    %w(csv)
  end

end
