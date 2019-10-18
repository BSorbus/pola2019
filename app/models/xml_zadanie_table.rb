class XmlZadanieTable < ApplicationRecord
  belongs_to :xml_projekt_table

  has_many :xml_kamien_milowy_tables, dependent: :delete_all, index_errors: true

  accepts_nested_attributes_for :xml_kamien_milowy_tables, reject_if: :all_blank, allow_destroy: true

end
