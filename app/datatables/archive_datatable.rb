class ArchiveDatatable < AjaxDatatablesRails::ActiveRecord
  include  ActionView::Helpers::NumberHelper

  def view_columns
    @view_columns ||= {
      id:         { source: "Archive.id", cond: :eq, searchable: false, orderable: false },
      name:       { source: "Archive.name", cond: :like, searchable: true, orderable: true },
      note:       { source: "Archive.note", cond: :like, searchable: true, orderable: true },
      components_folders_count:  { source: "Archive.components_folders_count", cond: :like, searchable: true, orderable: true },
      components_files_count:    { source: "Archive.components_files_count", cond: :like, searchable: true, orderable: true },
      components_files_size_sum: { source: "Archive.components_files_size_sum", cond: :like, searchable: true, orderable: true },
      user:       { source: "User.name",  cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:        record.id,
        name:      record.try(:name_as_link),
        note:      record.note_truncate,
        components_folders_count:  folders_count_badge(record).html_safe,
        components_files_count:    files_count_badge(record).html_safe,
        components_files_size_sum: number_to_human_size(record.components_files_size_sum),
        user:      record.author.name_as_link
      }
    end
  end

  private

  def get_raw_records
    # data = Archive.joins(:author, archivizations: [group: :users])
    #         .includes(archivizations: :archivization_type)
    #         .references(:author)

    # options[:eager_filter].present? ? data.for_user_in_archivizations(options[:eager_filter]).all : data.all

    Archive.joins(:author).all

  end

  def folders_count_badge(rec)
    "<span class='badge alert-info pull-right'> #{rec.components_folders_count} </span></div>"
  end

  def files_count_badge(rec)
    "<span class='badge alert-info pull-right'> #{rec.components_files_count} </span></div>"
  end

end
