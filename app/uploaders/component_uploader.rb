class ComponentUploader < CarrierWave::Uploader::Base
  include ActionView::Helpers::NumberHelper

  storage :file

  ###########################################################################
  # LOGGING HELPERS — minimalne, bezpieczne, nieinwazyjne
  ###########################################################################

  def log(msg)
    Rails.logger.info "[ComponentUploader] #{msg}"
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
  # MAIN PROCESS — identyczny jak w Twojej wersji
  ###########################################################################

  process :override_content_type_and_save_info

  def override_content_type_and_save_info
    ext = File.extname(file.file).delete('.').downcase.to_sym
    log "override_content_type: ext=#{ext}"

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
    end

    log "final content_type=#{file.content_type}"

    model.file_content_type = file.content_type if file.content_type
    model.file_size = number_to_human_size(file.size) if file.size

    log "model.file_content_type=#{model.file_content_type}"
    log "model.file_size=#{model.file_size}"
  end
end
