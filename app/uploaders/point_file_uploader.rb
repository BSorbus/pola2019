class PointFileUploader < CarrierWave::Uploader::Base

  storage :file

  ###########################################################################
  # LOGGING HELPERS
  ###########################################################################

  def log(msg)
    Rails.logger.info "[PointFileUploader] #{msg}"
  end

  def log_file_state(label, path)
    log "#{label}: #{path}"
    log "  exists? #{File.exist?(path)}"
    log "  dirname: #{File.dirname(path)} (exists? #{Dir.exist?(File.dirname(path))})"
  end

  ###########################################################################
  # STORE DIR / CACHE DIR
  ###########################################################################

  def store_dir
    dir = "#{Rails.application.secrets[:carrierwave_store_dir]}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    log "store_dir=#{dir}"
    dir
  end

  def cache_dir
    dir = Rails.application.secrets[:carrierwave_cache_dir]
    log "cache_dir=#{dir}"
    dir
  end

  ###########################################################################
  # EXTENSION WHITELIST
  ###########################################################################

  def extension_whitelist
    log "extension_whitelist called — allowed: csv"
    %w(csv)
  end

  ###########################################################################
  # MAIN PROCESS — FULL LOGGING
  ###########################################################################

  process :log_file_info

  def log_file_info
    log "log_file_info START"
    log "model=#{model.class} id=#{model.id}"
    log "mounted_as=#{mounted_as}"
    log "file.path=#{file.path}"
    log "file.original_filename=#{file.original_filename}"
    log "file.size=#{file.size}"
    log "Process UID=#{Process.uid}"
    log "ulimit -n=#{`ulimit -n`.strip rescue 'N/A'}"

    ext = File.extname(file.file).delete('.').downcase.to_sym
    log "extension=#{ext}"

    log_file_state("CSV file state", file.path)

    unless ext == :csv
      log "WARNING: Uploaded file is NOT CSV — extension=#{ext}"
    end

    log "log_file_info END"
  end

end
