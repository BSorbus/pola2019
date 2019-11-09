module UsersHelper

  def user_show_legend
    fa_icon("user", text: t("pages.user.show.title"))
  end

  def user_index_legend
    fa_icon("user", text: t("pages.user.index.title"))
  end

  def user_edit_legend(data_obj)
    fa_icon("user", text: t("pages.user.edit.title") + ": " + data_obj.fullname )
  end

  def user_new_legend(data_obj)
    fa_icon("user", text: t("pages.user.new.title"))
  end

  def user_info_legend(data_obj)
    user_show_legend + ": " + data_obj.fullname
  end

end