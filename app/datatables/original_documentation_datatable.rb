class OriginalDocumentationDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :truncate, :original_documentation_path, :download_original_documentation_path, :edit_original_documentation_path, :t

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:             { source: "OriginalDocumentation.id", cond: :eq, searchable: false, orderable: false },
      attached_file:  { source: "OriginalDocumentation.attached_file", cond: :like, searchable: true, orderable: true },
      note:           { source: "OriginalDocumentation.note",  cond: :like, searchable: true, orderable: true },
      user:           { source: "User.name",  cond: :like, searchable: true, orderable: true },
      updated_at:     { source: "OriginalDocumentation.updated_at",  cond: :like, searchable: true, orderable: true },
      file_size:      { source: "OriginalDocumentation.file_size",  cond: :like, searchable: false, orderable: false },
      action:         { source: "OriginalDocumentation.id",  cond: :like, searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        attached_file:  link_to(truncate(record.attached_file_identifier, length: 100), download_original_documentation_path(record.id), title: t('tooltip.download'), rel: 'tooltip') + '  ' +  
                          link_to(' ', @view.original_documentation_path(record.id), remote: true, class: 'fa fa-eye pull-right', title: "Podgląd", rel: 'tooltip'),
        note:           truncate(record.note, length: 50) + '  ' +  
                          link_to(' ', @view.edit_original_documentation_path(record.id), class: 'fa fa-edit pull-right', title: "Edycja", rel: 'tooltip'),
        file_size:      record.try(:file_size),
        user:           record.user.try(:name),
        updated_at:     record.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        action:         action_links(record).html_safe
      }
    end
  end


  private

  def get_raw_records
    if (options[:original_documentionable_id]).present? && (options[:original_documentionable_type]).present?
      OriginalDocumentation.joins(:user).where(original_documentionable_id: options[:original_documentionable_id], original_documentionable_type: options[:original_documentionable_type]).all
    else
      OriginalDocumentation.joins(:user).all
    end
  end

  def action_links(rec)
    "<div style='text-align: center'>
      <button-as-link ajax-path='" + original_documentation_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs fa fa-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
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
