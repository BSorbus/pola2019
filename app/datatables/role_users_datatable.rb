class RoleUsersDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :role_user_path, :role_users_path, :policy

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:         { source: "User.id", cond: :eq, searchable: false, orderable: false },
      name:       { source: "User.name", cond: :like, searchable: true, orderable: true },
      note:       { source: "User.note", cond: :like, searchable: true, orderable: true },
      has_role:   { source: "User.id",  searchable: false, orderable: false },
      action:     { source: "User.id", searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      role_has_user = Role.joins(:users).where(users: {id: record.id}, roles: {id: options[:only_for_current_role_id], special: true}).any?
      {
        id:         record.id,
        name:       record.try(:name_as_link),
        note:       record.note_truncate,
        has_role:   role_has_user ? '<div style="text-align: center"><div class="fa fa-check"></div></div>'.html_safe : '',
        action:     link_add_remove(record, role_has_user).html_safe
      }
    end
  end

  private

  def get_raw_records
    User.all
  end

  def link_add_remove(rec, has_role)
    if policy(:role).add_remove_role_user?
      if has_role
        "<div style='text-align: center'><button ajax-path='" + role_user_path(role_id: options[:only_for_current_role_id], id: rec.id) + "' ajax-method='DELETE' toastr-message='" + rec.name + "<br>...usunięto' class='btn btn-xs btn-danger fa fa-minus'></button></div>"
      else
        "<div style='text-align: center'><button ajax-path='" + role_users_path(role_id: options[:only_for_current_role_id], id: rec.id) + "' ajax-method='POST' toastr-message='" + rec.name + "<br>...dodano' class='btn btn-xs btn-success fa fa-plus'></button></div>"
      end
    else
      ""
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
