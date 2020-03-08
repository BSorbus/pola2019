class ThroughEventsAttachmentDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :truncate, :attachment_path, :download_attachment_path, :edit_attachment_path, :t, :fa_icon

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:             { source: "Attachment.id", cond: :eq, searchable: false, orderable: false },
      name:           { source: "Attachment.name", cond: :like, searchable: true, orderable: true },
      attachmenable:  { source: "Event.title", cond: :like, searchable: true, orderable: true },
      note:           { source: "Attachment.note",  cond: :like, searchable: true, orderable: true },
      user:           { source: "User.name",  cond: :like, searchable: true, orderable: true },
      updated_at:     { source: "Attachment.updated_at",  cond: :like, searchable: true, orderable: true },
      file_size:      { source: "Attachment.file_size",  cond: :like, searchable: false, orderable: false },
      action:         { source: "Attachment.id",  cond: :like, searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        name:           link_attached_file_or_folder(record),
        attachmenable:  record.attachmenable.title_as_link,
        note:           truncate(record.note, length: 50) + '  ' +  
                          link_to(' ', @view.edit_attachment_path(record.id), class: 'fa fa-edit pull-right', title: "Edycja", rel: 'tooltip'),
        file_size:      record.try(:file_size),
        user:           record.user.try(:name),
        updated_at:     record.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        action:         action_links(record).html_safe
      }
    end
  end


  private

  def get_raw_records
    if (options[:for_parent_id]).present? && (options[:for_parent_type]).present?
      parent_attachmenable = Project.find(options[:for_parent_id]) if options[:for_parent_type] == 'Project'

      data = parent_attachmenable.events_attachments.joins(:user).order('attachments.name_if_folder')
    end

    if options[:attachment_parent_filter].present? 
      data.only_for_parent(options[:attachment_parent_filter]).with_ancestor 
    else
      data.with_ancestor.roots
    end
  end

  def link_attached_file_or_folder(rec)
    if rec.attached_file.present?
      # rec.attached_file_identifier == rec.name  
      link_to(truncate("[#{truncate(rec.attachmenable.title, length: 15)}]/#{rec.name}", length: 100), download_attachment_path(rec.id), title: t('tooltip.download'), rel: 'tooltip') + '  ' +  
                              link_to(' ', @view.attachment_path(rec.id), remote: true, class: 'fa fa-eye pull-right', title: "Podgląd", rel: 'tooltip')
    else
      #rec.name_if_folder == rec.name
      breadcrumb_data = JSON.generate( {parent_id: rec.id, 
                                        ancestry_path: rec.ancestry_path,
                                        ancestor_ids: rec.ancestor_ids } )

      link_to fa_icon("folder", text: "[#{truncate(rec.attachmenable.title, length: 15)}]/#{rec.name}" ), "javascript:linkToThroughEventsAttachmentBreadcrumb( #{breadcrumb_data} )"
    end
  end


  def action_links(rec)
    "<div style='text-align: center'>
      <button-as-link ajax-path='" + attachment_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs fa fa-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
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
