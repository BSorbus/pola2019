class AbleUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ActionView::Helpers::NumberHelper

  storage :file

  def store_dir
    "#{Rails.application.secrets[:carrierwave_store_dir]}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    Rails.application.secrets[:carrierwave_cache_dir]
  end

  process :override_content_type_and_save_info

  ###########################################################################
  # LOGGING HELPERS
  ###########################################################################

  def log(msg)
    Rails.logger.info "[AbleUploader] #{msg}"
  end

  def log_file_state(label, path)
    log "#{label}: #{path}"
    log "  exists? #{File.exist?(path)}"
    log "  dirname: #{File.dirname(path)} (exists? #{Dir.exist?(File.dirname(path))})"
  end

  ###########################################################################
  # MAIN FIX: SAFE RAR/ZIP PROCESSING WITH FULL LOGGING
  ###########################################################################

  def list_compressable(format)
    ext = File.extname(file.file).delete('.').to_sym
    log "list_compressable: ext=#{ext}, current_path=#{current_path}"

    case ext
    when :rar
      list_file_from_rar(file)
    when :zip
      list_file_from_zip(file)
    else
      log "list_compressable: extension #{ext} not compressable"
    end
  end

  def list_file_from_rar(file)
    log "RAR processing START"
    tmp_dir = only_file_path(current_path)
    new_file_name = file.file.gsub('.rar', '.png')

    log "RAR tmp_dir=#{tmp_dir}"
    log "RAR new_file_name=#{new_file_name}"
    log_file_state("RAR current_path", current_path)

    # ensure tmp_dir exists
    unless Dir.exist?(tmp_dir)
      log "RAR mkdir tmp_dir=#{tmp_dir}"
      FileUtils.mkdir_p(tmp_dir)
    end

    # run unrar
    log "RAR running: unrar lb #{file.file}"
    unrar_output = `unrar lb #{file.file} 2>&1`
    log "RAR unrar output:\n#{unrar_output}"

    # run convert
    convert_cmd = "unrar lb #{file.file} | convert -background black -fill white -page 11x17 -pointsize 14 -font Courier text:- #{new_file_name}"
    log "RAR convert cmd: #{convert_cmd}"
    convert_output = `#{convert_cmd} 2>&1`
    log "RAR convert output:\n#{convert_output}"

    # append multiple PNGs
    all_tmp_files = Dir["#{tmp_dir}*.png"]
    log "RAR all_tmp_files=#{all_tmp_files.inspect}"

    if all_tmp_files.size > 1
      all_tmp_files.each do |current_file|
        append_cmd = "convert #{new_file_name} #{current_file} -append #{new_file_name}"
        log "RAR append cmd: #{append_cmd}"
        append_output = `#{append_cmd} 2>&1`
        log "RAR append output:\n#{append_output}"
      end
    end

    # rename
    log_file_state("RAR rename source", new_file_name)
    log_file_state("RAR rename target", current_path)

    begin
      File.rename(new_file_name, current_path)
      log "RAR rename SUCCESS"
    rescue => e
      log "RAR rename ERROR: #{e.class}: #{e.message}"
    end

    log "RAR processing END"
  end

  def list_file_from_zip(file)
    log "ZIP processing START"
    tmp_dir = only_file_path(current_path)
    new_file_name = file.file.gsub('.zip', '.png')

    log "ZIP tmp_dir=#{tmp_dir}"
    log "ZIP new_file_name=#{new_file_name}"
    log_file_state("ZIP current_path", current_path)

    unless Dir.exist?(tmp_dir)
      log "ZIP mkdir tmp_dir=#{tmp_dir}"
      FileUtils.mkdir_p(tmp_dir)
    end

    unzip_cmd = "unzip -Z1 #{file.file} | convert -background black -fill white -page 11x17 -pointsize 14 -font Courier text:- #{new_file_name}"
    log "ZIP convert cmd: #{unzip_cmd}"
    unzip_output = `#{unzip_cmd} 2>&1`
    log "ZIP convert output:\n#{unzip_output}"

    all_tmp_files = Dir["#{tmp_dir}*.png"]
    log "ZIP all_tmp_files=#{all_tmp_files.inspect}"

    if all_tmp_files.size > 1
      all_tmp_files.each do |current_file|
        append_cmd = "convert #{new_file_name} #{current_file} -append #{new_file_name}"
        log "ZIP append cmd: #{append_cmd}"
        append_output = `#{append_cmd} 2>&1`
        log "ZIP append output:\n#{append_output}"
      end
    end

    log_file_state("ZIP rename source", new_file_name)
    log_file_state("ZIP rename target", current_path)

    begin
      File.rename(new_file_name, current_path)
      log "ZIP rename SUCCESS"
    rescue => e
      log "ZIP rename ERROR: #{e.class}: #{e.message}"
    end

    log "ZIP processing END"
  end

  ###########################################################################
  # THUMB VERSION
  ###########################################################################

  version :thumb do
    process convert_convertable: :png, if: :convertable?
    process list_compressable: :png, if: :compressable?
    process resize_to_fit: [800, 800], if: :image?
    process convert: :png, if: :image?

    def full_filename(for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end

  ###########################################################################
  # CONTENT TYPE
  ###########################################################################

  def override_content_type_and_save_info
    ext = File.extname(file.file).delete('.').downcase.to_sym
    log "override_content_type: ext=#{ext}, file=#{file.file}"

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

    log "override_content_type: final=#{file.content_type}"

    model.file_content_type = file.content_type if file.content_type
    model.file_size = number_to_human_size(file.size) if file.size
  end

  ###########################################################################
  # HELPERS
  ###########################################################################

  private

  def convertable?(file)
    pdf?(file) || docx?(file) || xlsx?(file) || pptx?(file)
  end

  def compressable?(file)
    rar?(file) || zip?(file)
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

  def rar?(file)
    model.file_content_type == 'application/vnd.rar'
  end

  def zip?(file)
    model.file_content_type == 'application/zip'
  end

  def only_file_path(path_with_file_name)
    length_path = path_with_file_name.length
    length_filename = path_with_file_name.reverse.index('/')
    path_with_file_name[0, (length_path - length_filename)]
  end
end
