class PhotoUploader < CarrierWave::Uploader::Base
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


  version :thumb do

    process convert_convertable: :png, if: :convertable?
    process resize_to_fit: [800, 800], if: :image?
    process convert: :png, if: :image?
    #process convert: :png, if: :not_convertable?

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end

  end

  version :miniature do
    process convert_convertable: :png, if: :convertable?
    process resize_to_fit: [104, 78], if: :image?
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

    tmp_file = file.path
    photo = MiniExiftool.new "#{tmp_file}"

    model.latitude = dms_to_float(photo.gpslatitude) if photo && photo.gpslatitude
    model.longitude = dms_to_float(photo.gpslongitude) if photo && photo.gpslongitude
    model.photo_created_at = photo.createdate if photo && photo.createdate
  end

  private

    def dms_to_float(lat_or_long)
      lat_or_long.gsub!(/deg/,'').gsub!(/\"/,'').gsub!("'","")

      # 49 46 7.90 N
      value = lat_or_long.split[0].to_f + lat_or_long.split[1].to_f/60 + lat_or_long.split[2].to_f/3600
      value = -1 * value if lat_or_long.split[3] == 'S' || lat_or_long.split[3] == 'W'

      return value
    end


    def convertable?(file)
      # puts '-------------------- check convertable?(file) -------------------------------'
      # puts model.file_content_type
      # puts file.content_type
      # puts ( pdf?(file) || docx?(file) || xlsx?(file) || pptx?(file) )
      # puts '-----------------------------------------------------------------------------'
      ( pdf?(file) || docx?(file) || xlsx?(file) || pptx?(file) )
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
end