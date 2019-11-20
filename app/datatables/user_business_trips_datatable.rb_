class UserBusinessTripsDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :truncate

  def view_columns
    @view_columns ||= {
      id:                { source: "BusinessTrip.id", cond: :eq, searchable: false, orderable: false },
      number:            { source: "BusinessTrip.number", cond: :like, searchable: true, orderable: true },
      start_date:        { source: "BusinessTrip.start_date", cond: :like, searchable: true, orderable: true },
      end_date:          { source: "BusinessTrip.end_date", cond: :like, searchable: true, orderable: true },
      destination:       { source: "BusinessTrip.destination", cond: :like, searchable: true, orderable: true },
      purpose:           { source: "BusinessTrip.purpose", cond: :like, searchable: true, orderable: true },
      status:            { source: "BusinessTripStatus.name", cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:                record.id,
        number:            record.try(:number_as_link),
        start_date:        record.start_date.present? ? record.start_date.strftime("%Y-%m-%d") : '' ,
        end_date:          record.end_date.present? ? record.end_date.strftime("%Y-%m-%d") : '' ,
        destination:       record.try(:destination),
        purpose:           truncate(record.try(:purpose), length: 100),
        status:            record.business_trip_status.try(:name)
      }
    end
  end

  private

  def get_raw_records
    BusinessTrip.joins(:business_trip_status).references(:business_trip_status).where(employee_id: options[:only_for_current_user_id]).all
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
