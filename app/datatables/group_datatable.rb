class GroupDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      id:         { source: "Group.id", cond: :eq, searchable: false, orderable: false },
      name:       { source: "Group.name", cond: :like, searchable: true, orderable: true },
      note:       { source: "Group.note", cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:         record.id,
        name:       record.try(:name_as_link),
        note:       record.note_truncate
      }
    end
  end

  private

  def get_raw_records
    Group.distinct
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
