require 'csv'

class PointFile < ApplicationRecord
  enum status: [:inactive, :active]

  mount_uploader :load_file, PointFileUploader

  # relations
  belongs_to :project

  has_many :ww_points, dependent: :delete_all
  has_many :zs_points, dependent: :delete_all

  # validates
  validates :load_file, presence: true,
                        file_size: { less_than: 50.megabytes }
  validates :status, presence: true,
                    uniqueness: { scope: [:project_id] }, if: :status_active?

  before_save :loading_file_is_valid?, on: :create


  def loading_file_is_valid?
    unless check_csv_file
      errors.add(:load_file, '"' + load_file.file.original_filename + '" nie jest prawidłowym plikiem wygenerowanym przy użyciu "Formularz planowania zasięgów i sieci NGA ver. 1.1/1.2.0/1.19.x".')
      throw :abort 
    end
  end

  def status_active?
    self.active?
  end

  def fullname
    "#{self.load_file_identifier}"
  end

  def check_csv_file
    # Wygenerowano przy użyciu "Formularz planowania zasięgów i sieci NGA"
    # Data wygenerowania: 2017-02-07 18:22:42
    # Wersja aplikacji: 1.1

    # Wygenerowano przy użyciu "Formularz planowania zasięgów i sieci NGA"
    # Data wygenerowania: 2017-06-06 12:10:22
    # Wersja aplikacji: 1.2.0

    # Wygenerowano przez FPZiS (1.19.2), 2018-05-04 10:22:14


    required_line1_ver_1_1_or_1_2_0 = '# Wygenerowano przy użyciu "Formularz planowania zasięgów i sieci NGA"'
    required_line3_1_1 = '# Wersja aplikacji: 1.1'
    required_line3_1_2_0 = '# Wersja aplikacji: 1.2.0'

    required_line1_ver_1_19_x = '# Wygenerowano przez FPZiS (1.19.'


    line1 = File.open("#{self.load_file.file.path}", "r").each_line.take(1).last
    line1 = line1.strip.gsub(/[\n]/, '') if line1.present?

    line1sub = line1[0..32] if line1.present?

    line3 = File.open("#{self.load_file.file.path}", "r").each_line.take(3).last
    line3 = line3.strip.gsub(/[\n]/, '') if line3.present?

    ( 
      (line1 == required_line1_ver_1_1_or_1_2_0) && ((line3 == required_line3_1_1) || (line3 == required_line3_1_2_0))
    ) ||
    ( line1sub == required_line1_ver_1_19_x )

  end

  def load_data_from_csv_file
    @ww_points = []
    @zs_points = []

    CSV.foreach("#{self.load_file.file.path}", {  
                                                 headers: false, 
                                                 converters: nil,
                                                 skip_blanks: true,
                                                 liberal_parsing: true,
                                                 col_sep: ',' }) do |row|

      case row[0].first(2)
      when "OI"
        update_io(row)
      when "DP"
        update_dp(row)
      when "WW"
        insert_ww_points(row)                        
      when "ZS"
        insert_zs_points(row)                        
      when "WS"
        update_ws(row)
      end if row[0].first(1) != "#"

    end 

    self.save
    WwPoint.import(@ww_points)
    ZsPoint.import(@zs_points)
  end

  private
    def update_io(current_row)
      self.oi_2  = "#{current_row[1]}"
      self.oi_3  = "#{current_row[2]}"
      self.oi_4  = "#{current_row[3]}"
      self.oi_5  = current_row[4].squish.gsub(/["]/, "").to_i
      self.oi_6  = current_row[5].squish.gsub(/["]/, "").to_i
      self.oi_7  = current_row[6].squish.gsub(/["]/, "").to_i
      self.oi_8  = current_row[7].squish.gsub(/["]/, "").to_i
      self.oi_9  = current_row[8].squish.gsub(/["]/, "").to_i
      self.oi_10 = current_row[9].squish.gsub(/["]/, "").to_i
    end

    def update_dp(current_row)
      self.dp_2  = "#{current_row[1]}"
      self.dp_3  = "#{current_row[2]}"
      self.dp_4  = "#{current_row[3]}"
      self.dp_5  = "#{current_row[4]}"
      self.dp_6  = "#{current_row[5]}"
      self.dp_7  = "#{current_row[6]}"
      self.dp_8  = "#{current_row[7]}".gsub(/[^0-9,.-]/, "")
    end

    def update_ws(current_row)
      self.ws_2 = current_row[1].squish.gsub(/["]/, "").to_i
      self.ws_3 = current_row[2].squish.gsub(/["]/, "").to_i
      self.ws_4 = current_row[3].squish.gsub(/["]/, "").to_i
      self.ws_5 = current_row[4].squish.gsub(/["]/, "").to_i
      self.ws_6 = current_row[5].squish.gsub(/["]/, "").to_i
      self.ws_7 = current_row[6].squish.gsub(/["]/, "").to_i
    end

    def insert_ww_points(current_row)                        
      @ww_points << WwPoint.new(
        point_file_id: self.id, 
        ww_2:  "#{current_row[1]}",
        ww_3:  "#{current_row[2]}",
        ww_4:  "#{current_row[3]}",
        ww_5:  "#{current_row[4]}",
        ww_6:  "#{current_row[5]}",
        ww_7:  "#{current_row[6]}",
        ww_8:  "#{current_row[7]}",
        ww_9:  "#{current_row[8]}",
        ww_10: "#{current_row[9]}",
        ww_11: "#{current_row[10]}",
        ww_12: "#{current_row[11]}",
        ww_13: "#{current_row[12]}",
        ww_14: current_row[13].squish.gsub(/["]/, "").to_f,
        ww_15: current_row[14].squish.gsub(/["]/, "").to_f,
        ww_16: "#{current_row[15]}"
      )
    end

    def insert_zs_points(current_row)                        
      @zs_points << ZsPoint.new(
        point_file_id: self.id, 
        zs_2:  "#{current_row[1]}",
        zs_3:  "#{current_row[2]}",
        zs_4:  "#{current_row[3]}",
        zs_5:  "#{current_row[4]}",
        zs_6:  "#{current_row[5]}",
        zs_7:  "#{current_row[6]}",
        zs_8:  "#{current_row[7]}",
        zs_9:  "#{current_row[8]}",
        zs_10: "#{current_row[9]}",
        zs_11: "#{current_row[10]}",
        zs_12: "#{current_row[11]}",
        zs_13: current_row[12].squish.gsub(/["]/, "").to_f,
        zs_14: current_row[13].squish.gsub(/["]/, "").to_f,
        zs_15: "#{current_row[14]}",
        zs_16: current_row[15].squish.gsub(/["]/, "").to_i,
        zs_17: current_row[16].squish.gsub(/["]/, "").to_i,
        zs_18: "#{current_row[17]}",
        zs_19: current_row[18].squish.gsub(/["]/, "").to_i,
        zs_20: current_row[19].squish.gsub(/["]/, "").to_i,
        zs_21: current_row[20].squish.gsub(/["]/, "").to_i
      )
    end

end
