class CustomerDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      id:             { source: "Customer.id", cond: :eq, searchable: false, orderable: false },
      name:           { source: "Customer.name", cond: :like, searchable: true, orderable: true },
      nip:            { source: "Customer.nip",  cond: :like, searchable: true, orderable: true },
      regon:          { source: "Customer.regon",  cond: :like, searchable: true, orderable: true },
      rpt:            { source: "Customer.rpt",  cond: :like, searchable: true, orderable: true },
      address_city:   { source: "Customer.address_city",  cond: :like, searchable: true, orderable: true },
      address_street: { source: "Customer.address_street",  cond: :like, searchable: true, orderable: true },
      address_house:  { source: "Customer.address_house",  cond: :like, searchable: true, orderable: true },
      address_number: { source: "Customer.address_number",  cond: :like, searchable: true, orderable: true },
      flat:           { source: "Customer.id", cond: filter_custom_column_condition }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        name:           record.name_as_link,
        nip:            record.nip,
        regon:          record.regon,
        rpt:            record.rpt,
        address_city:   record.address_city,
        address_street: record.address_street,
        address_house:  record.address_house,
        address_number: record.address_number,
        flat:           record.try(:flat_assigned_projects)
      }
    end
  end

  private

  def get_raw_records
    options[:eager_filter].present? ? Customer.for_user_in_accessorizations(options[:eager_filter]).all : Customer.all
  end


  def filter_custom_column_condition
    #->(column) { ::Arel::Nodes::SqlLiteral.new(column.field.to_s).matches("#{ column.search.value }%") }
    ->(column, value) {
        sanitize_search_text = Loofah.fragment(value).text;
        sql_str = "(customers.id IN (SELECT projects.customer_id FROM projects WHERE projects.number ilike '%#{sanitize_search_text}%'))";
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
