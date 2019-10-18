class UserDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      id:                   { source: "User.id", cond: :eq, searchable: false, orderable: false },
      name:                 { source: "User.name", cond: :like, searchable: true, orderable: true },
      current_sign_in_ip:   { source: "User.current_sign_in_ip",  cond: :like, searchable: true, orderable: true },
      current_sign_in_at:   { source: "User.current_sign_in_at",  cond: :like, searchable: true, orderable: true },
      last_activity_at:     { source: "User.last_activity_at",  cond: :like, searchable: true, orderable: true },
      password_changed_at:  { source: "User.password_changed_at",  cond: :like, searchable: true, orderable: true },
      deleted_at:           { source: "User.deleted_at",  cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:                   record.id,
        name:                 record.name_as_link,
        current_sign_in_ip:   record.current_sign_in_ip,
        current_sign_in_at:   record.current_sign_in_at.present? ? record.current_sign_in_at.strftime("%Y-%m-%d %H:%M:%S") : '' ,
        last_activity_at:     record.last_activity_at.present? ? record.last_activity_at.strftime("%Y-%m-%d %H:%M:%S") : '' ,
        password_changed_at:  record.password_changed_at.present? ? record.password_changed_at.strftime("%Y-%m-%d %H:%M:%S") : '' ,
        deleted_at:           record.deleted_at.present? ? record.deleted_at.strftime("%Y-%m-%d %H:%M:%S") : ''
      }
    end
  end

  private

  def get_raw_records
    User.distinct
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
