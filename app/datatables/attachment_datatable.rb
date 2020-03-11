class AttachmentDatatable < AjaxDatatablesRails::ActiveRecord
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
        name:           link_attached_file_or_folder(record).html_safe,
        note:           truncate(record.note, length: 50) + '  ' +  
                          link_to(' ', @view.edit_attachment_path(record.id), class: 'fa fa-edit pull-right', title: "Edycja", rel: 'tooltip'),
        file_size:      file_size_or_badge(record),
        user:           record.user.name_as_link,
#        user:           record.user.try(:name),
        updated_at:     record.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        action:         action_links(record).html_safe
      }
    end
  end

  private

  # def get_raw_records
  #   if (options[:attachmenable_id]).present? && (options[:attachmenable_type]).present?
  #     folders = Attachment.joins(:user).where(attachmenable_id: options[:attachmenable_id], attachmenable_type: options[:attachmenable_type]).folders_only.order_folders_files.all
  #     files   = Attachment.joins(:user).where(attachmenable_id: options[:attachmenable_id], attachmenable_type: options[:attachmenable_type]).files_only.order_folders_files.all
  #   else
  #     folders = Attachment.joins(:user).folders_only.order_folders_files.all
  #     files   = Attachment.joins(:user).files_only.order_folders_files.all
  #   end
  #   all_data = folders.or(files)
  # end

  def get_raw_records
    if (options[:attachmenable_id]).present? && (options[:attachmenable_type]).present?
      #data = Attachment.joins(:user).where(attachmenable_id: options[:attachmenable_id], attachmenable_type: options[:attachmenable_type]).order(:name_if_folder)
      data = Attachment.joins(:user).where(attachmenable_id: options[:attachmenable_id], attachmenable_type: options[:attachmenable_type]).order('attachments.name_if_folder')
    else
      data = Attachment.joins(:user)
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
      link_to(truncate(rec.name, length: 100), download_attachment_path(rec.id), title: t('tooltip.download'), rel: 'tooltip') + '  ' +  
                              link_to(' ', @view.attachment_path(rec.id), remote: true, class: 'fa fa-eye pull-right', title: "Podgląd", rel: 'tooltip')
    else
      #rec.name_if_folder == rec.name
      breadcrumb_data = JSON.generate( {parent_id: rec.id, 
                                        ancestry_path: rec.ancestry_path,
                                        ancestor_ids: rec.ancestor_ids } )

#       link_to( rec.name, '#', onclick: "linkToAttachmentBreadcrumb( #{breadcrumb_data} )", remote: true, class: 'fa fa-folder', title: "Podgląd", rel: 'tooltip')
      fa_icon("folder" ) + link_to( ' ' + rec.name, '#', onclick: "linkToAttachmentBreadcrumb( #{breadcrumb_data} )", remote: true)


#      link_to "#{'<strong>'+rec.name+'</strong>'}", "#", onclick: "linkToAttachmentBreadcrumb( #{breadcrumb_data} )", remote: true

#      link_to fa_icon("folder", text: rec.name ), "javascript:linkToAttachmentBreadcrumb( #{breadcrumb_data} );return false;"
    end
  end

  def file_size_or_badge(rec)
    if rec.attached_file.present?
      rec.try(:file_size)
    else
      badge(rec).html_safe
    end
  end

  def badge(rec)
    count = rec.leaves.where(name_if_folder: nil).size
    "<div style='text-align: center'><span class='badge alert-info'>" + "#{count}" + "</span></div>"
  end

  def action_links(rec)
    "<div style='text-align: center'>
      <button-as-link ajax-path='" + attachment_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs fa fa-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
    </div>"
  end


  # ==== These methods represent the basic operations to perform on records


  # def sort_records(records)
  #   sort_by = datatable.orders.inject([]) do |queries, order|
  #     column = order.column
  #     queries << order.query(column.sort_query) if column && column.orderable?
  #     queries
  #   end
  #   records.order(Arel.sql(sort_by.join(', ')))
  # end

  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
