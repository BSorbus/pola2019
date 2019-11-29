module CustomersHelper

  ICON = "flag"

  def customer_show_legend
    fa_icon(ICON, text: t("pages.customer.show.title"))
  end

  def customer_index_legend
    fa_icon(ICON, text: t("pages.customer.index.title"))
  end

  def customer_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.customer.edit.title") + ": " + data_obj.fullname )
  end

  def customer_new_legend(data_obj)
    fa_icon(ICON, text: t("pages.customer.new.title"))
  end

  def customer_info_legend(data_obj)
    customer_show_legend + ": " + data_obj.fullname
  end

end
