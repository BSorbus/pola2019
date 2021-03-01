class PointFileZsPointsDatatable < AjaxDatatablesRails::ActiveRecord

  include ActionView::Helpers::NumberHelper

  def view_columns
    @view_columns ||= {
      id:     { source: "ZsPoint.id",    cond: :eq, searchable: false, orderable: false },
      zs_2:   { source: "ZsPoint.zs_2",  cond: :like, searchable: true, orderable: true },
      zs_3:   { source: "ZsPoint.zs_3",  cond: :like, searchable: true, orderable: true },
      zs_4:   { source: "ZsPoint.zs_4",  cond: :like, searchable: true, orderable: true },
      zs_5:   { source: "ZsPoint.zs_5",  cond: :like, searchable: true, orderable: true },
      zs_6:   { source: "ZsPoint.zs_6",  cond: :like, searchable: true, orderable: true },
      zs_7:   { source: "ZsPoint.zs_7",  cond: :like, searchable: true, orderable: true },
      zs_8:   { source: "ZsPoint.zs_8",  cond: :like, searchable: true, orderable: true },
      zs_9:   { source: "ZsPoint.zs_9",  cond: :like, searchable: true, orderable: true },
      zs_10:  { source: "ZsPoint.zs_10", cond: :like, searchable: true, orderable: true },
      zs_11:  { source: "ZsPoint.zs_11", cond: :like, searchable: true, orderable: true },
      zs_12:  { source: "ZsPoint.zs_12", cond: :like, searchable: true, orderable: true },
      zs_13:  { source: "ZsPoint.zs_13", cond: :like, searchable: true, orderable: true },
      zs_14:  { source: "ZsPoint.zs_14", cond: :like, searchable: true, orderable: true },
      zs_15:  { source: "ZsPoint.zs_15", cond: :like, searchable: true, orderable: true },
      zs_16:  { source: "ZsPoint.zs_16", cond: :like, searchable: true, orderable: true },
      zs_17:  { source: "ZsPoint.zs_17", cond: :like, searchable: true, orderable: true },
      zs_1022:  { source: "ZsPoint.zs_1022", cond: :like, searchable: true, orderable: true },
      zs_18:  { source: "ZsPoint.zs_18", cond: :like, searchable: true, orderable: true },
      zs_19:  { source: "ZsPoint.zs_19", cond: :like, searchable: true, orderable: true },
      zs_20:  { source: "ZsPoint.zs_20", cond: :like, searchable: true, orderable: true },
      zs_21:  { source: "ZsPoint.zs_21", cond: :like, searchable: true, orderable: true },
      zs_1023:  { source: "ZsPoint.zs_1023", cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:     record.id,
        zs_2:   record.zs_2,
        zs_3:   record.zs_3,
        zs_4:   record.zs_4,
        zs_5:   record.zs_5,
        zs_6:   record.zs_6,
        zs_7:   record.zs_7,
        zs_8:   record.zs_8,
        zs_9:   record.zs_9,
        zs_10:  record.zs_10,
        zs_11:  record.zs_11,
        zs_12:  record.zs_12,
        zs_13:  number_with_precision(record.zs_13, precision: 8, separator: '.'),
        zs_14:  number_with_precision(record.zs_14, precision: 8, separator: '.'),
        zs_15:  record.zs_15,
        zs_16:  record.zs_16,
        zs_17:  record.zs_17,
        zs_1022:  record.zs_1022,
        zs_18:  record.zs_18,
        zs_19:  record.zs_19,
        zs_20:  record.zs_20,
        zs_21:  record.zs_21,
        zs_1023:  record.zs_1023
      }
    end
  end

  private

  def get_raw_records
    ZsPoint.where(point_file_id: options[:only_for_current_point_file_id]).all
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
