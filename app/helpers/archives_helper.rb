module ArchivesHelper
  ICON = "archive"

  def archive_show_legend
    fa_icon(ICON, text: t("pages.archive.show.title"))
  end

  def archive_index_legend
    fa_icon(ICON, text: t("pages.archive.index.title"))
  end

  def archive_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.archive.edit.title") + ": " + data_obj.fullname )
  end

  def archive_new_legend(data_obj)
    fa_icon(ICON, text: t("pages.archive.new.title"))
  end

  def archive_info_legend(data_obj)
    archive_show_legend + ": " + data_obj.fullname
  end

end
