class ArchiveDatatable < AjaxDatatablesRails::ActiveRecord

  include  ActionView::Helpers::NumberHelper

  def view_columns
    @view_columns ||= {
      id:         { source: "Archive.id", cond: :eq, searchable: false, orderable: false },
      name:       { source: "Archive.name", cond: :like, searchable: true, orderable: true },
      note:       { source: "Archive.note", cond: :like, searchable: true, orderable: true }
#     flat:       { source: "Archive.id", cond: filter_custom_column_condition }
    }
  end

  def data
    records.map do |record|
      {
        id:        record.id,
        name:      record.try(:name_as_link),
        note:      record.note_truncate
#       flat:              record.flat_assigned_users
      }
    end
  end

  private

  def get_raw_records
    data = Archive.all

#    options[:eager_filter].present? ? data.for_user_in_accessorizations(options[:eager_filter]).all : data.all
  end

  def filter_custom_column_condition
    #->(column) { ::Arel::Nodes::SqlLiteral.new(column.field.to_s).matches("#{ column.search.value }%") }
    ->(column, value) {
        sanitize_search_text = Loofah.fragment(value).text;
        sql_str = "(archives.id IN (" +
          "SELECT accessorizations.archive_id FROM accessorizations, users WHERE " + 
          "accessorizations.user_id = users.id AND " + 
          "users.name ilike '%#{sanitize_search_text}%' " +
          "UNION " +
          "SELECT accessorizations.archive_id FROM accessorizations, roles WHERE " + 
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
