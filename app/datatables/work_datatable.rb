class WorkDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      id:             { source: "Work.id", cond: :eq, searchable: false, orderable: false },
      created_at:     { source: "Work.created_at", cond: :like, searchable: true, orderable: true },
      created_by:     { source: "User.name",  cond: :like, searchable: true, orderable: true },
      action:         { source: "Work.action",  cond: :like, searchable: true, orderable: true },
      trackable_type: { source: "Work.trackable_type",  cond: :like, searchable: true, orderable: true },
      trackable_id:   { source: "Work.trackable_id",  cond: :like, searchable: true, orderable: true },
      parameters:     { source: "Work.parameters",  cond: :like, searchable: true, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        created_at:     record.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        created_by:     record.user ? record.user.name_as_link : record.user_id,
#        created_by:     record.user ? link_to( record.user.fullname, record.user ) : record.user_id,
        action:         record.action,
        trackable_type: record.trackable_type,
        trackable_id:   record.link_to_trackable_url,
#        trackable_id:   record.trackable ? link_to( record.trackable.fullname, record.trackable_url ) : record.trackable_id,
        parameters:     record.pretty_parameters
      }
    end
  end

  private

  def get_raw_records
    if (options[:trackable_id]).present? && (options[:trackable_type]).present?
      Work.where(trackable_id: options[:trackable_id], trackable_type: options[:trackable_type]).includes(:user).references(:user).all
    elsif (options[:only_for_current_user_id]).present?
      Work.where(user_id: options[:only_for_current_user_id]).includes(:user).references(:user).all
    else
      Work.includes(:user).references(:user).all
    end
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
