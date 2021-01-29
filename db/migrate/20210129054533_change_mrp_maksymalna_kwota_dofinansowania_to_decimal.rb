class ChangeMrpMaksymalnaKwotaDofinansowaniaToDecimal < ActiveRecord::Migration[5.2]

  def up
    change_column :xml_partner_tables, :mrp_maksymalna_kwota_dofinansowania, :decimal, precision: 15, scale: 2
  end

  def down
    change_column :xml_partner_tables, :mrp_maksymalna_kwota_dofinansowania, :integer
  end

end
