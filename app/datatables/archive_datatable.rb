class ArchiveDatatable < AjaxDatatablesRails::ActiveRecord
  include  ActionView::Helpers::NumberHelper

  def view_columns
    @view_columns ||= {
      id:         { source: "Archive.id", cond: :eq, searchable: false, orderable: false },
      name:       { source: "Archive.name", cond: :like, searchable: true, orderable: true },
      note:       { source: "Archive.note", cond: :like, searchable: true, orderable: true },
      user:       { source: "User.name",  cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:        record.id,
        name:      record.try(:name_as_link),
        note:      record.note_truncate,
        user:      record.author.name_as_link
      }
    end
  end

  private

  def get_raw_records
    puts '--------------------------------get_raw_records------------------------------'
    if options[:eager_filter].present?
      # Archive.joins(:author, archivizations: {group: [:users]}).references(:author, archivizations: {group: [:users]})
      #   .where(archivizations: {group: {users: {id: [options[:eager_filter]]}}}).distinct
      Archive.joins(:author, archivizations: {group: [:users]})
        .where(archivizations: {group: {members: {user: [options[:eager_filter]] }}}).all
    else
      Archive.joins(:author).all
    end
  end

  def badge(rec)
    rec.attachments_count > 0 ? "<div> #{number_to_human_size(rec.attachments_file_size_sum)} <span class='badge alert-info pull-right'> #{rec.attachments_count} </span></div>" : "<div></div>"
  end

end
