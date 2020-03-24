class ThroughEventsAttachmentDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :truncate, :attachment_path, :download_attachment_path, :edit_attachment_path, :t, :fa_icon, :number_to_human_size

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:             { source: "Attachment.id", cond: :eq, searchable: false, orderable: false },
      name_if_folder: { source: "Attachment.name_if_folder", cond: :eq, searchable: false, orderable: false },
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
        name_if_folder: record.name_if_folder.present? ? record.name_if_folder : '',
        name:           link_attached_file_or_folder(record),
        attachmenable:  record.attachmenable.title_as_link,
        note:           truncate(record.note, length: 50) + '  ' +  
                          link_to(' ', @view.edit_attachment_path(record.id), class: 'fa fa-edit pull-right', title: "Edycja", rel: 'tooltip'),
        file_size:      file_size_or_sum_files_size_and_badge(record).html_safe,
        user:           record.user.name_as_link,
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
      # link_to(truncate("[#{truncate(rec.attachmenable.title, length: 15)}]/#{rec.name}", length: 100), download_attachment_path(rec.id), title: t('tooltip.download'), rel: 'tooltip') + '  ' +  
      #                         link_to(' ', @view.attachment_path(rec.id), remote: true, class: 'fa fa-eye pull-right', title: "Podgląd", rel: 'tooltip')
      link_to(truncate(rec.name, length: 100), @view.attachment_path(rec.id), remote: true, title: t('tooltip.show'), rel: 'tooltip')
    else
      #rec.name_if_folder == rec.name
      breadcrumb_data = JSON.generate( {parent_id: rec.id, 
                                        ancestry_path: rec.ancestry_path,
                                        ancestor_ids: rec.ancestor_ids } )

      fa_icon("folder" ) + link_to( ' ' + "[#{truncate(rec.attachmenable.title, length: 20)}]/#{rec.name}", '#', onclick: "linkToThroughEventsAttachmentBreadcrumb( #{breadcrumb_data} )", remote: true)

#      link_to fa_icon("folder", text: "[#{truncate(rec.attachmenable.title, length: 20)}]/#{rec.name}" ), "#", onclik: "linkToThroughEventsAttachmentBreadcrumb( #{breadcrumb_data} );return false;"
#      link_to fa_icon("folder", text: "[#{truncate(rec.attachmenable.title, length: 20)}]/#{rec.name}" ), "javascript:linkToThroughEventsAttachmentBreadcrumb( #{breadcrumb_data} )"
    end
  end

  def file_size_or_sum_files_size_and_badge(rec)
    if rec.attached_file.present?      
      "<div>#{rec.file_size}</div>"
    else
      badge(rec)
    end
  end

  def badge(rec)
    count = rec.leaves.where.not(attached_file: nil).size
    sum_size = rec.leaves.where.not(attached_file: nil).map {|a| a.attached_file.file.size }.sum
    count > 0 ? "<div> #{number_to_human_size(sum_size)} <span class='badge alert-info pull-right'> #{count} </span></div>" : "<div></div>"
  end

  def action_links(rec)
    if rec.is_folder?
      "<div style='text-align: center'>
        <button-as-link ajax-path='" + attachment_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs fa fa-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
      </div>"
    else
      "<div style='text-align: center'>
        <button-as-link ajax-path='" + download_attachment_path(rec.id) + "' ajax-method='GET' class='btn btn-xs fa fa-download text-primary' title='Pobierz' rel='tooltip'></button-as-link>
        <button-as-link ajax-path='" + attachment_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs fa fa-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
      </div>"
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
