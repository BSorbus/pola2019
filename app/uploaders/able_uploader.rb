class AbleUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  include ActionView::Helpers::NumberHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  process :override_content_type_and_save_info


  def convert_convertable(format)
    manipulate! do |img| # this is ::MiniMagick::Image instance
      img.format(format.to_s.downcase, 0)
      img
    end
  end

  def format(format, page = 0)
    @info.clear

    if @tempfile
      new_tempfile = MiniMagick::Utilities.tempfile(".#{format}")
      new_path = new_tempfile.path
    else
      new_path = path.sub(/\.\w+$/, ".#{format}")
    end

    MiniMagick::Tool::Convert.new do |convert|
      convert << (page ? "#{path}[#{page}]" : path)
      yield convert if block_given?
      convert << new_path
    end

  end

  def list_compressable(format)
    # File.delete(current_path)
    # FileUtils.cp("tmp/" + file.name.gsub("/", "-"), current_path)
    # file.file == current_path
    # puts File.extname(current_path).delete('.').to_sym
    # puts file.file
    # puts File.extname(file.file).delete('.').to_sym
    case File.extname(file.file).delete('.').to_sym
    when :rar
      list_file_from_rar(file)
    when :zip
      list_file_from_zip(file)
    end
  end

  def list_file_from_rar(file)
    new_file_name = file.file.gsub('.rar', '.png')
    system("unrar lb #{file.file} | convert -background black -fill lightgray -page 11x17 -pointsize 14 -font Courier text:- #{new_file_name}")
    File.rename new_file_name, current_path
  end

  def list_file_from_zip(file)
    puts 'Am :zip file'
    puts 'List compressed files from .zip and create png'    
  end

  version :thumb do

    process convert_convertable: :png, if: :convertable?
    process list_compressable: :png, if: :compressable?
    process resize_to_fit: [800, 800], if: :image?
    process convert: :png, if: :image?

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end

  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end



  # def size_range
  #   0..2.megabytes
  # end


  def override_content_type_and_save_info
    case File.extname(file.file).delete('.').to_sym
    when :xlsx
      file.content_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    when :docx
      file.content_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    when :pptx
      file.content_type = 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
    end

    # if File.extname(file.file).delete('.').to_sym == :xlsx
    #   file.content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    # end
    # if File.extname(file.file).delete('.').to_sym == :docx
    #   file.content_type='application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    # end
    # if File.extname(file.file).delete('.').to_sym == :pptx
    #   file.content_type='application/vnd.openxmlformats-officedocument.presentationml.presentation'
    # end

    model.file_content_type = file.content_type if file.content_type
    model.file_size = number_to_human_size(file.size) if file.size
  end

  private

    def convertable?(file)
      ( pdf?(file) || docx?(file) || xlsx?(file) || pptx?(file) )
    end

    def compressable?(file)
      ( rar?(file) || zip?(file) )
    end


    def image?(file)
      model.file_content_type.include? 'image'
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
end