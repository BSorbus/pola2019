module EnrollmentHelper

  def enrollment_show_legend
    fa_icon("briefcase", text: t("pages.enrollment.show.title"))
  end

  def enrollment_index_legend
    fa_icon("briefcase", text: t("pages.enrollment.index.title"))
  end

  def enrollment_edit_legend(data_obj)
    fa_icon("briefcase", text: t("pages.enrollment.edit.title") + ": " + data_obj.fullname )
  end

  def enrollment_new_legend(data_obj)
    fa_icon("briefcase", text: t("pages.enrollment.new.title"))
  end

  def enrollment_info_legend(data_obj)
    enrollment_show_legend + ": " + data_obj.fullname
  end

end
