class PhotoDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :truncate, :photo_path, :download_photo_path, :edit_photo_path, :t, :image_tag

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:               { source: "Photo.id", cond: :eq, searchable: false, orderable: false },
      miniature:        { source: "Photo.attached_file", cond: :eq, searchable: false, orderable: false },
      photo_created_at: { source: "Photo.photo_created_at",  cond: :like, searchable: true, orderable: true },
      latitude:         { source: "Photo.latitude",  cond: :like, searchable: true, orderable: true },
      longitude:        { source: "Photo.longitude",  cond: :like, searchable: true, orderable: true },
      attached_file:    { source: "Photo.attached_file", cond: :like, searchable: true, orderable: true },
      note:             { source: "Photo.note",  cond: :like, searchable: true, orderable: true },
      user:             { source: "User.name",  cond: :like, searchable: true, orderable: true },
      updated_at:       { source: "Photo.updated_at",  cond: :like, searchable: true, orderable: true },
      file_size:        { source: "Photo.file_size",  cond: :like, searchable: false, orderable: false },
      action:           { source: "Photo.id",  cond: :like, searchable: false, orderable: false }
    }
  end

  def data

    records.map do |record|
      {
        id:               record.id,
        miniature:        link_to( image_tag(record.attached_file_url(:miniature), style: 'max-height:104px;width:auto;'), @view.photo_path(record.id), remote: true, title: "Podgląd", rel: 'tooltip'),
        photo_created_at: record.photo_created_at.present? ? record.photo_created_at.strftime("%Y-%m-%d %H:%M:%S") : '' ,
        latitude:         record.latitude,
        longitude:        record.longitude,
        attached_file:    link_to(truncate(record.attached_file_identifier, length: 100), download_photo_path(record.id), title: t('tooltip.download'), rel: 'tooltip'),
        note:             truncate(record.note, length: 50) + '  ' +  
                            link_to(' ', @view.edit_photo_path(record.id), class: 'fa fa-edit pull-right', title: "Edycja", rel: 'tooltip'),
        file_size:        record.try(:file_size),
        user:             record.user.try(:name),
        updated_at:       record.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        action:           action_links(record).html_safe
      }
    end
  end


  private

  def get_raw_records
    if (options[:photoable_id]).present? && (options[:photoable_type]).present?
      Photo.joins(:user).where(photoable_id: options[:photoable_id], photoable_type: options[:photoable_type]).all
    else
      Photo.joins(:user).all
    end
  end

  def action_links(rec)
    "<div style='text-align: center'>
      <button-as-link ajax-path='" + photo_path(rec.id) + "' ajax-method='DELETE' class='btn btn-xs fa fa-trash text-danger' title='Usuń' rel='tooltip'></button-as-link>
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
