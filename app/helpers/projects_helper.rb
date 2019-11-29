module ProjectsHelper

  ICON = "project-diagram"

  def project_show_legend
    fa_icon(ICON, text: t("pages.project.show.title"))
  end

  def project_index_legend
    fa_icon(ICON, text: t("pages.project.index.title"))
  end

  def project_edit_legend(data_obj)
  	fa_icon(ICON, text: t("pages.project.edit.title") + ": " + data_obj.fullname )
  end

  def project_new_legend(data_obj)
  	fa_icon(ICON, text: t("pages.project.new.title"))
  end

  def project_info_legend(data_obj)
    project_show_legend + ": " + data_obj.fullname
  end

end
