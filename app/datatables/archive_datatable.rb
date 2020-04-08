class ArchiveDatatable < AjaxDatatablesRails::ActiveRecord
  include  ActionView::Helpers::NumberHelper

  def view_columns
    @view_columns ||= {
      id:             { source: "Archive.id", cond: :eq, searchable: false, orderable: false },
      name:           { source: "Archive.name", cond: :like, searchable: true, orderable: true },
      note:           { source: "Archive.note", cond: :like, searchable: true, orderable: true },
      folders_count:  { source: "Archive.folders_count", cond: :like, searchable: true, orderable: false },
      files_count:    { source: "Archive.files_count", cond: :like, searchable: true, orderable: false },
      files_size_sum: { source: "Archive.files_size_sum", cond: :like, searchable: true, orderable: false },
      user:           { source: "User.name",  cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        name:           record.try(:name_as_link),
        note:           record.note_truncate,
        folders_count:  folders_count_badge(record).html_safe,
        files_count:    files_count_badge(record).html_safe,
        files_size_sum: number_to_human_size(files_size_sum(record)),
        user:           record.author.name_as_link
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
    count = rec.components.where(component_file: nil).size
    "<span class='badge alert-info pull-right'> #{count} </span></div>"
  end

  def files_count_badge(rec)
    count = rec.components.where.not(component_file: nil).size
    "<span class='badge alert-info pull-right'> #{count} </span></div>"
  end

  def files_size_sum(rec)
    rec.components.where.not(component_file: nil).map {|a| a.component_file.file.size }.sum
  end

end
