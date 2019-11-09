module RolesHelper

  def role_show_legend
    fa_icon("user-tag", text: t("pages.role.show.title"))
  end

  def role_index_legend
    fa_icon("user-tag", text: t("pages.role.index.title"))
  end

  def role_edit_legend(data_obj)
    fa_icon("user-tag", text: t("pages.role.edit.title") + ": " + data_obj.fullname )
  end

  def role_new_legend(data_obj)
    fa_icon("user-tag", text: t("pages.role.new.title"))
  end

  def role_info_legend(data_obj)
    role_show_legend + ": " + data_obj.fullname
  end

end
