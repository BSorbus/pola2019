class ThroughEventsOpinionDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :truncate, :opinion_path, :download_opinion_path, :edit_opinion_path, :t

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:             { source: "Opinion.id", cond: :eq, searchable: false, orderable: false },
      attached_file:  { source: "Opinion.attached_file", cond: :like, searchable: true, orderable: true },
      opinionable:    { source: "Event.title", cond: :like, searchable: true, orderable: true },
      note:           { source: "Opinion.note",  cond: :like, searchable: true, orderable: true },
      user:           { source: "User.name",  cond: :like, searchable: true, orderable: true },
      updated_at:     { source: "Opinion.updated_at",  cond: :like, searchable: true, orderable: true },
      file_size:      { source: "Opinion.file_size",  cond: :like, searchable: false, orderable: false },
      action:         { source: "Opinion.id",  cond: :like, searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        attached_file:  link_to(truncate(record.attached_file_identifier, length: 100), download_opinion_path(record.id), title: t('tooltip.download'), rel: 'tooltip') + '  ' +  
                          link_to(' ', @view.opinion_path(record.id), remote: true, class: 'fa fa-eye pull-right', title: "Podgląd", rel: 'tooltip'),
        opinionable:    record.opinionable.title_as_link,
        note:           truncate(record.note, length: 50) + '  ' +  
                          link_to(' ', @view.edit_opinion_path(record.id), class: 'fa fa-edit pull-right', title: "Edycja", rel: 'tooltip'),
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
      if options[:for_parent_type] == 'Project'
        parent_opinionable = Project.find(options[:for_parent_id])
        parent_opinionable.events_opinions.joins(:user).all
      end
    end
  end

  def action_links(rec)
    "<div style='text-align: center'>
      <button-as-link ajax-path='" + opinion_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs fa fa-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
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
