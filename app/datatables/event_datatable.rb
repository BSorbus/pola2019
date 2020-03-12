class EventDatatable < AjaxDatatablesRails::ActiveRecord

  include  ActionView::Helpers::NumberHelper

  def view_columns
    @view_columns ||= {
      id:                { source: "Event.id", cond: :eq, searchable: false, orderable: false },
      title:             { source: "Event.title", cond: :like, searchable: true, orderable: true },
      type:              { source: "EventType.name", cond: :like, searchable: true, orderable: true },
      errand:            { source: "Errand.number",  cond: :like, searchable: true, orderable: true },
      project:           { source: "Project.number",  cond: :like, searchable: true, orderable: true },
      customer:          { source: "Customer.name",  cond: :like, searchable: true, orderable: true },
      end_date:          { source: "Event.end_date", cond: :like, searchable: true, orderable: true },
      status:            { source: "EventStatus.name", cond: :like, searchable: true, orderable: true },
      effect:            { source: "EventEffect.name", cond: :like, searchable: true, orderable: true },
      updated_at:        { source: "Event.updated_at", cond: :like, searchable: true, orderable: true },
      attachments_count: { source: "Event.attachments_count", cond: :eq, searchable: true, orderable: true },
      flat:              { source: "Event.id", cond: filter_custom_column_condition }
    }
  end

  def data
    records.map do |record|
      {
        id:                record.id,
        title:             record.try(:title_as_link),
        type:              record.event_type.try(:name),
        errand:            record.errand.try(:number_as_link),
        project:           record.project.try(:number_as_link),
        customer:          record.project.customer.try(:name_as_link),
        end_date:          record.end_date.present? ? record.end_date.strftime("%Y-%m-%d %H:%M") : '' ,
        status:            record.event_status.try(:name),
        effect:            record.event_effect.try(:name),
        updated_at:        record.updated_at.strftime("%Y-%m-%d %H:%M"),
        attachments_count: badge(record).html_safe,
        flat:              record.flat_assigned_users
      }
    end
  end

  private

  def get_raw_records
    data = Event.joins(:event_type, :errand, :event_status, [project: :customer])
      .includes(:event_effect)
      .references(:event_type, :errand, :event_status, :project, :customer, :event_effect)

    options[:eager_filter].present? ? data.for_user_in_accessorizations(options[:eager_filter]).all : data.all
  end

  def filter_custom_column_condition
    #->(column) { ::Arel::Nodes::SqlLiteral.new(column.field.to_s).matches("#{ column.search.value }%") }
    ->(column, value) {
        sanitize_search_text = Loofah.fragment(value).text;
        sql_str = "(events.id IN (" +
          "SELECT accessorizations.event_id FROM accessorizations, users WHERE " + 
          "accessorizations.user_id = users.id AND " + 
          "users.name ilike '%#{sanitize_search_text}%' " +
          "UNION " +
          "SELECT accessorizations.event_id FROM accessorizations, roles WHERE " + 
          "accessorizations.role_id = roles.id AND " + 
          "roles.name ilike '%#{sanitize_search_text}%' " +
          "))";
        ::Arel::Nodes::SqlLiteral.new("#{sql_str}") 
        }
  end

  def badge(rec)
    rec.attachments_count > 0 ? "<div> #{number_to_human_size(rec.attachments_file_size_sum)} <span class='badge alert-info pull-right'> #{rec.attachments_count} </span></div>" : "<div></div>"
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
