class InspectionProtocolDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :truncate, :inspection_protocol_path, :download_inspection_protocol_path, :edit_inspection_protocol_path, :t

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:             { source: "InspectionProtocol.id", cond: :eq, searchable: false, orderable: false },
      attached_file:  { source: "InspectionProtocol.attached_file", cond: :like, searchable: true, orderable: true },
      note:           { source: "InspectionProtocol.note",  cond: :like, searchable: true, orderable: true },
      user:           { source: "User.name",  cond: :like, searchable: true, orderable: true },
      updated_at:     { source: "InspectionProtocol.updated_at",  cond: :like, searchable: true, orderable: true },
      file_size:      { source: "InspectionProtocol.file_size",  cond: :like, searchable: false, orderable: false },
      action:         { source: "InspectionProtocol.id",  cond: :like, searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        attached_file:  link_to(truncate(record.attached_file_identifier, length: 100), download_inspection_protocol_path(record.id), title: t('tooltip.download'), rel: 'tooltip') + '  ' +  
                          link_to(' ', @view.inspection_protocol_path(record.id), remote: true, class: 'fa fa-eye pull-right', title: "Podgląd", rel: 'tooltip'),
        note:           truncate(record.note, length: 50) + '  ' +  
                          link_to(' ', @view.edit_inspection_protocol_path(record.id), class: 'fa fa-edit pull-right', title: "Edycja", rel: 'tooltip'),
        file_size:      record.try(:file_size),
        user:           record.user.try(:name),
        updated_at:     record.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        action:         action_links(record).html_safe
      }
    end
  end


  private

  def get_raw_records
    if (options[:inspectionable_id]).present? && (options[:inspectionable_type]).present?
      InspectionProtocol.joins(:user).where(inspectionable_id: options[:inspectionable_id], inspectionable_type: options[:inspectionable_type]).all
    else
      InspectionProtocol.joins(:user).all
    end
  end

  def action_links(rec)
    "<div style='text-align: center'>
      <button-as-link ajax-path='" + inspection_protocol_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs fa fa-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
    </div>"
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
