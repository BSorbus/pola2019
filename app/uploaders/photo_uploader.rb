class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ActionView::Helpers::NumberHelper

  storage :file

  ###########################################################################
  # LOGGING HELPERS
  ###########################################################################

  def log(msg)
    Rails.logger.info "[PhotoUploader] #{msg}"
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

    ###########################################################################
    # EXIF / GPS LOGGING
    ###########################################################################

    tmp_file = file.path
    log_file_state("EXIF source file", tmp_file)

    begin
      photo = MiniExiftool.new(tmp_file)
      log "EXIF loaded successfully"
    rescue => e
      log "EXIF ERROR loading MiniExiftool: #{e.class}: #{e.message}"
      return
    end

    log "EXIF raw gpslatitude=#{photo.gpslatitude.inspect}"
    log "EXIF raw gpslongitude=#{photo.gpslongitude.inspect}"
    log "EXIF raw createdate=#{photo.createdate.inspect}"

    begin
      if photo && photo.gpslatitude
        model.latitude = dms_to_float(photo.gpslatitude)
        log "model.latitude=#{model.latitude}"
      end

      if photo && photo.gpslongitude
        model.longitude = dms_to_float(photo.gpslongitude)
        log "model.longitude=#{model.longitude}"
      end

      if photo && photo.createdate
        model.photo_created_at = photo.createdate
        log "model.photo_created_at=#{model.photo_created_at}"
      end
    rescue => e
      log "EXIF ERROR saving GPS/createdate: #{e.class}: #{e.message}"
    end

    log "override_content_type_and_save_info END"
  end

  ###########################################################################
  # THUMBNAILS
  ###########################################################################

  version :thumb do
    process convert_convertable: :png, if: :convertable?
    process resize_to_fit: [800, 800], if: :image?
    process convert: :png, if: :image?

    def full_filename(for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end

  version :miniature do
    process convert_convertable: :png, if: :convertable?
    process resize_to_fit: [104, 78], if: :image?
    process convert: :png, if: :image?

    def full_filename(for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end

  ###########################################################################
  # HELPERS
  ###########################################################################

  private

  def dms_to_float(lat_or_long)
    log "dms_to_float input=#{lat_or_long.inspect}"

    lat_or_long = lat_or_long.gsub(/deg/,'').gsub(/\"/,'').gsub("'", "")
    log "dms_to_float cleaned=#{lat_or_long.inspect}"

    parts = lat_or_long.split
    log "dms_to_float parts=#{parts.inspect}"

    value = parts[0].to_f + parts[1].to_f/60 + parts[2].to_f/3600
    value = -value if parts[3] == 'S' || parts[3] == 'W'

    log "dms_to_float result=#{value}"
    value
  end

  def convertable?(file)
    pdf?(file) || docx?(file) || xlsx?(file) || pptx?(file)
  end

  def image?(file)
    model.file_content_type.include?('image')
  end

  def pdf?(file)
    model.file_content_type == 'application/pdf'
  end

  def docx?(file)
    model.file_content_type == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  end

  def xlsx?(file)
    model.file_content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  def pptx?(file)
    model.file_content_type == 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  end
end
