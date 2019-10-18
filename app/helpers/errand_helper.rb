module ErrandHelper

  def errand_show_legend
    fa_icon("tasks", text: t("pages.errand.show.title") )
  end

  def errand_index_legend
    fa_icon("tasks", text: t("pages.errand.index.title") )
  end

  def errand_edit_legend(data_obj)
    fa_icon("tasks", text: t("pages.errand.edit.title") + ": " + data_obj.fullname )
  end

  def errand_new_legend(data_obj)
    fa_icon("tasks", text: t("pages.errand.new.title"))
  end

  def errand_info_legend(data_obj)
    errand_show_legend + ": " + data_obj.fullname
  end

end
