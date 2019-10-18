class AttachmentDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :truncate, :attachment_path, :edit_attachment_path, :t

  def view_columns
    @view_columns ||= {
      id:            { source: "Attachment.id", cond: :eq, searchable: false, orderable: false },
      attached_file: { source: "Attachment.attached_file", cond: :like, searchable: true, orderable: true },
      note:          { source: "Attachment.note",  cond: :like, searchable: true, orderable: true },
      user:          { source: "User.name",  cond: :like, searchable: true, orderable: true },
      updated_at:    { source: "Attachment.updated_at",  cond: :like, searchable: true, orderable: true },
      file_size:     { source: "Attachment.file_size",  cond: :like, searchable: false, orderable: false },
      action:        { source: "Attachment.id",  cond: :like, searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id:            record.id,
        attached_file: link_to(truncate(record.attached_file_identifier, length: 150), attachment_path(record.id), title: t('tooltip.download'), rel: 'tooltip'),
        note:          truncate(record.note, length: 50) + '  ' +  link_to(' ', @view.edit_attachment_path(record.id), class: 'glyphicon glyphicon-edit', title: "Edycja", rel: 'tooltip'),
        file_size:     record.try(:file_size),
        user:          record.user.try(:name),
        updated_at:    record.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        action:        action_links(record).html_safe
        #action:        link_to(record.attached_file.file.identifier, attachment_path(record.id))
        #action:        link_to(' ', @view.attachment_path(record.id), 
        #                 class: 'glyphicon glyphicon-eye-open', title: 'Pokaż', rel: 'tooltip')
      }
    end
  end


  private

  def get_raw_records
    if (options[:attachmenable_id]).present? && (options[:attachmenable_type]).present?
      Attachment.joins(:user).where(attachmenable_id: options[:attachmenable_id], attachmenable_type: options[:attachmenable_type]).all
    else
      Attachment.joins(:user).all
    end
  end

  def action_links(rec)
    # link_to(' ', @view.edit_attachment_path(rec.id), 
    #                 class: 'glyphicon glyphicon-edit', title: "Edycja", rel: 'tooltip') + 
    #   "    " +
    # link_to(' ', @view.attachment_path(rec.id), 
    #                     method: :delete, 
    #                     data: { confirm: "Czy na pewno chcesz usunąć ten wpis?" }, 
    #                     class: "glyphicon glyphicon-trash", title: 'Usuń', rel: 'tooltip')  

# OK   "<div style='text-align: center'><button-as-link ajax-path='" + attachment_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs glyphicon glyphicon-trash text-danger' title='Usuń' rel='tooltip'></button-as-link></div>"

    "<div style='text-align: center'>
      <button-as-link ajax-path='" + attachment_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs glyphicon glyphicon-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
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
