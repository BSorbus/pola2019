module MeasurementsHelper

  ICON = "ruler-combined"

  def measurement_index_legend
    fa_icon(ICON, text: t("pages.measurement.index.title"))
  end

  def measurement_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.measurement.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_measurement_index_legend
    fa_icon(ICON, text: t("pages.measurement.through_events_index.title"))
  end

end