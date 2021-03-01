class PointFileWwPointsDatatable < AjaxDatatablesRails::ActiveRecord

  include ActionView::Helpers::NumberHelper

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
      ww_17:  { source: "WwPoint.ww_17", cond: :like, searchable: true, orderable: true },
      ww_18:  { source: "WwPoint.ww_18", cond: :like, searchable: true, orderable: true },
      ww_19:  { source: "WwPoint.ww_19", cond: :like, searchable: true, orderable: true }
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
        ww_17:  record.ww_17,
        ww_18:  number_with_precision(record.ww_18, precision: 0),
        ww_19:  number_with_precision(record.ww_19, precision: 2, separator: '.')
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
