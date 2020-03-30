class Archive < ApplicationRecord
  include ActionView::Helpers::TextHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user
  has_many :works, as: :trackable

  has_many :archivizations, dependent: :destroy
  has_many :accesses_groups, through: :archivizations, source: :group

 
  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :archivizations, reject_if: :all_blank, allow_destroy: true



  def fullname
    "#{name}"
  end

  def name_as_link
    "<a href=#{url_helpers.archive_path(self)}>#{self.name}</a>".html_safe
  end

  def note_truncate
    truncate(Loofah.fragment(self.note).text, length: 100)
  end


end
