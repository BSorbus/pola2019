class PointFileWwPointsDatatable < AjaxDatatablesRails::Base

  include ActionView::Helpers::NumberHelper

  # t.references :point_file, foreign_key: true
  # t.string :ww_2,  limit:  10, index: true
  # t.string :ww_3,  limit: 100, index: true
  # t.string :ww_4,  limit: 100, index: true
  # t.string :ww_5,  limit: 100, index: true
  # t.string :ww_6,  limit: 100, index: true
  # t.string :ww_7,  limit:   7, index: true
  # t.string :ww_8,  limit: 100, index: true
  # t.string :ww_9,  limit:   7, index: true
  # t.string :ww_10, limit: 250, index: true
  # t.string :ww_11, limit:   5, index: true
  # t.string :ww_12, limit:  50, index: true
  # t.string :ww_13, limit:   6, index: true
  # t.decimal :ww_14, precision: 7, scale: 4, index: true
  # t.decimal :ww_15, precision: 7, scale: 4, index: true
  # t.string :ww_16, limit: 100, index: true


  def view_columns
    @view_columns ||= {
      id:     { source: "WwPoint.id",    cond: :eq, searchable: false, orderable: false },
      ww_2:   { source: "WwPoint.ww_2",  cond: :like, searchable: true, orderable: true },
      ww_3:   { source: "WwPoint.ww_3",  cond: :like, searchable: true, orderable: true },
      ww_4:   { source: "WwPoint.ww_4",  cond: :like, searchable: true, orderable: true },
      ww_5:   { source: "WwPoint.ww_5",  cond: :like, searchable: true, orderable: true },
      ww_6:   { source: "WwPoint.ww_6",  cond: :like, searchable: true, orderable: true },
      ww_7:   { source: "WwPoint.ww_7",  cond: :like, searchable: true, orderable: true },
      ww_8:   { source: "WwPoint.ww_8",  cond: :like, searchable: true, orderable: true },
      ww_9:   { source: "WwPoint.ww_9",  cond: :like, searchable: true, orderable: true },
      ww_10:  { source: "WwPoint.ww_10", cond: :like, searchable: true, orderable: true },
      ww_11:  { source: "WwPoint.ww_11", cond: :like, searchable: true, orderable: true },
      ww_12:  { source: "WwPoint.ww_12", cond: :like, searchable: true, orderable: true },
      ww_13:  { source: "WwPoint.ww_13", cond: :like, searchable: true, orderable: true },
      ww_14:  { source: "WwPoint.ww_14", cond: :like, searchable: true, orderable: true },
      ww_15:  { source: "WwPoint.ww_15", cond: :like, searchable: true, orderable: true },
      ww_16:  { source: "WwPoint.ww_16", cond: :like, searchable: true, orderable: true },
    }
  end

  def data
    records.map do |record|
      {
        id:     record.id,
        ww_2:   record.ww_2,
        ww_3:   record.ww_3,
        ww_4:   record.ww_4,
        ww_5:   record.ww_5,
        ww_6:   record.ww_6,
        ww_7:   record.ww_7,
        ww_8:   record.ww_8,
        ww_9:   record.ww_9,
        ww_10:  record.ww_10,
        ww_11:  record.ww_11,
        ww_12:  record.ww_12,
        ww_13:  record.ww_13,
        ww_14:  number_with_precision(record.ww_14, precision: 4, separator: '.'),
        ww_15:  number_with_precision(record.ww_15, precision: 4, separator: '.'),
        ww_16:  record.ww_16,
      }
    end
  end

  private

  def get_raw_records
    WwPoint.where(point_file_id: options[:only_for_current_point_file_id]).all
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
