class XmlPartnerTable < ApplicationRecord
  belongs_to :proposal_file

  has_many :xml_miejsce_realizacji_tables, dependent: :delete_all, index_errors: true

  accepts_nested_attributes_for :xml_miejsce_realizacji_tables, reject_if: :all_blank, allow_destroy: true

end
