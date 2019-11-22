module PointFilesHelper

  def point_file_show_legend
    fa_icon("calendar", text: t("pages.point_file.show.title"))
  end

  def point_file_index_legend
    fa_icon("calendar", text: t("pages.point_file.index.title"))
  end

  def point_file_edit_legend(data_obj)
    fa_icon("calendar", text: t("pages.point_file.edit.title") + ": " + data_obj.fullname )
  end

  def point_file_new_legend(data_obj)
    fa_icon("calendar", text: t("pages.point_file.new.title"))
  end

  def point_file_info_legend(data_obj)
    point_file_show_legend + ": " + data_obj.fullname
  end

end
