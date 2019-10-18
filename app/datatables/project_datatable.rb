class ProjectDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      id:         { source: "Project.id", cond: :eq, searchable: false, orderable: false },
      number:     { source: "Project.number", cond: :like, searchable: true, orderable: true },
      enrollment: { source: "Enrollment.name", cond: :like, searchable: true, orderable: true },
      area_id:    { source: "Project.area_id", cond: :like, searchable: true, orderable: true },
      area_name:  { source: "Project.area_name", cond: :like, searchable: true, orderable: true },
      status:     { source: "ProjectStatus.name", cond: :like, searchable: true, orderable: true },
      customer:   { source: "Customer.name", cond: :like, searchable: true, orderable: true },
      flat:       { source: "Project.id", cond: filter_custom_column_condition }
    }
  end

  def data
    records.map do |record|
      {
        id:         record.id,
        number:     record.number_as_link,
        enrollment: record.enrollment.name_as_link,
        area_id:    record.try(:area_id),
        area_name:  record.try(:area_name),
        status:     record.project_status.name,
        customer:   record.customer.name_as_link_truncate,
        flat:       record.flat_assigned_events_with_status
      }
    end
  end

  private

  def get_raw_records
    if options[:only_for_current_customer_id].present?
      data = Project.joins(:enrollment, :project_status, :customer)
        .includes(:events).references(:enrollment, :project_status, :customer, :events)
        .where(customer_id: options[:only_for_current_customer_id])
    else 
      data = Project.joins(:enrollment, :project_status, :customer)
        .includes(:events).references(:enrollment, :project_status, :customer, :events)
    end
    options[:eager_filter].present? ? data.for_user_in_accessorizations(options[:eager_filter]).all : data.all
  end


  def filter_custom_column_condition
    #->(column) { ::Arel::Nodes::SqlLiteral.new(column.field.to_s).matches("#{ column.search.value }%") }
    ->(column, value) {
        sanitize_search_text = Loofah.fragment(value).text;
        sql_str = "(projects.id IN (" +
          "SELECT events.project_id FROM events WHERE " + 
          "events.title ilike '%#{sanitize_search_text}%' " +
          "UNION " +
          "SELECT events.project_id FROM events, event_statuses WHERE " + 
          "events.event_status_id = event_statuses.id AND " + 
          "event_statuses.name ilike '%#{sanitize_search_text}%' " +
          "))";
        ::Arel::Nodes::SqlLiteral.new("#{sql_str}") 
        }
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
