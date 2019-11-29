module PhotosHelper

  ICON = "image"

  def photo_index_legend
    fa_icon(ICON, text: t("pages.photo.index.title"))
  end

  def photo_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.photo.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_photo_index_legend
    fa_icon(ICON, text: t("pages.photo.through_events_index.title"))
  end

end