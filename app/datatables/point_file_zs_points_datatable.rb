class PointFileZsPointsDatatable < AjaxDatatablesRails::Base

  include ActionView::Helpers::NumberHelper

  # t.bigint "point_file_id"
  # t.string "zs_2", limit: 10
  # t.string "zs_3", limit: 100
  # t.string "zs_4", limit: 100
  # t.string "zs_5", limit: 100
  # t.string "zs_6", limit: 100
  # t.string "zs_7", limit: 7
  # t.string "zs_8", limit: 100
  # t.string "zs_9", limit: 7
  # t.string "zs_10", limit: 250
  # t.string "zs_11", limit: 5
  # t.string "zs_12", limit: 50
  # t.decimal "zs_13", precision: 7, scale: 4
  # t.decimal "zs_14", precision: 7, scale: 4
  # t.string "zs_15", limit: 100
  # t.integer "zs_16"
  # t.integer "zs_17"
  # t.string "zs_18", limit: 100
  # t.integer "zs_19"
  # t.integer "zs_20"
  # t.integer "zs_21"


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
      zs_18:  { source: "ZsPoint.zs_18", cond: :like, searchable: true, orderable: true },
      zs_19:  { source: "ZsPoint.zs_19", cond: :like, searchable: true, orderable: true },
      zs_20:  { source: "ZsPoint.zs_20", cond: :like, searchable: true, orderable: true },
      zs_21:  { source: "ZsPoint.zs_21", cond: :like, searchable: true, orderable: true }
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
        zs_13:  number_with_precision(record.zs_13, precision: 4, separator: '.'),
        zs_14:  number_with_precision(record.zs_14, precision: 4, separator: '.'),
        zs_15:  record.zs_15,
        zs_16:  record.zs_16,
        zs_17:  record.zs_17,
        zs_18:  record.zs_18,
        zs_19:  record.zs_19,
        zs_20:  record.zs_20,
        zs_21:  record.zs_21
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
