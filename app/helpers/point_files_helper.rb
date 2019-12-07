module PointFilesHelper

  ICON = "file-csv"

  def point_file_dropdown_legend
    fa_icon(ICON, text: t("pages.point_file.dropdown.title"))
  end

  def point_file_show_legend
    fa_icon(ICON, text: t("pages.point_file.show.title"))
  end

  def point_file_index_legend
    fa_icon(ICON, text: t("pages.point_file.index.title"))
  end

  def point_file_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.point_file.edit.title") + ": " + data_obj.fullname )
  end

  def point_file_new_legend(data_obj)
    fa_icon(ICON, text: t("pages.point_file.new.title"))
  end

  def point_file_info_legend(data_obj)
    point_file_show_legend + ": " + data_obj.fullname
  end


  ICON_OI_DATA = "map-marker-alt"
  def point_file_oi_data_show_legend
    fa_icon(ICON_OI_DATA, text: t("pages.oi_data.show.title"))
  end
  def point_file_oi_data_info_legend(data_obj)
    point_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_OI_DATA, text: t("pages.oi_data.show.title") ) 
  end

  ICON_ZS_POINT = "home"
  def point_file_zs_show_legend
    fa_icon(ICON_ZS_POINT, text: t("pages.zs_point.index.title"))
  end
  def point_file_zs_info_legend(data_obj)
    point_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_ZS_POINT, text: t("pages.zs_point.index.title") ) 
  end

  ICON_WW_POINT = "home"
  def point_file_ww_show_legend
    fa_icon(ICON_WW_POINT, text: t("pages.ww_point.index.title"))
  end
  def point_file_ww_info_legend(data_obj)
    point_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_WW_POINT, text: t("pages.ww_point.index.title") ) 
  end

  ICON_MAP = "globe"
  def point_file_map_show_legend
    fa_icon(ICON_MAP, text: t("pages.map.index.title"))
  end
  def point_file_map_info_legend(data_obj)
    point_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_MAP, text: t("pages.map.index.title") ) 
  end

end
