class ComponentUploader < CarrierWave::Uploader::Base
  include ActionView::Helpers::NumberHelper

  storage :file

  ###########################################################################
  # LOGGING HELPERS
  ###########################################################################

  def log(msg)
    Rails.logger.info "[ComponentUploader] #{msg}"
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
  # MAIN PROCESS
  ###########################################################################

  process :override_content_type_and_save_info

  def override_content_type_and_save_info
    log "override_content_type_and_save_info START"
    log "model=#{model.class} id=#{model.id}"
    log "mounted_as=#{mounted_as}"
    log "file.path=#{file.path}"
    log "file.original_filename=#{file.original_filename}"
    log "file.size=#{file.size}"
    log "Process UID=#{Process.uid}"
    log "ulimit -n=#{`ulimit -n`.strip rescue 'N/A'}"

    ext = File.extname(file.file).delete('.').downcase.to_sym
    log "extension=#{ext}"

    begin
      case ext
      when :xlsx
        file.content_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      when :docx
        file.content_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      when :pptx
        file.content_type = 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
      when :rar
        file.content_type = 'application/vnd.rar'
      when :zip
        file.content_type = 'application/zip'
      when :bat
        file.content_type = 'application/x-msdos-program'
      when :cmd
        file.content_type = 'application/cmd'
      when :exe
        file.content_type = 'application/x-msdownload'
      when :msi
        file.content_type = 'application/x-msi'
      when :php
        file.content_type = 'application/x-php'
      when :py
        file.content_type = 'application/x-python'
      when :vbs
        file.content_type = 'application/x-vbs'
      else
        log "UNKNOWN EXTENSION — no override"
      end
    rescue => e
      log "ERROR setting content_type: #{e.class}: #{e.message}"
    end

    log "FINAL content_type=#{file.content_type}"

    begin
      model.file_content_type = file.content_type if file.content_type
      model.file_size = number_to_human_size(file.size) if file.size
      log "model.file_content_type=#{model.file_content_type}"
      log "model.file_size=#{model.file_size}"
    rescue => e
      log "ERROR saving model info: #{e.class}: #{e.message}"
    end

    log "override_content_type_and_save_info END"
  end
end
