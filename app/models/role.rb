class Role < ApplicationRecord
  include ActionView::Helpers::TextHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  has_and_belongs_to_many :users
  has_many :accessorizations, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

  # scope
  scope :only_not_special, -> { where(special: false) }  

  def fullname
    "#{name}"
  end

  def name_as_link
    "<a href=#{url_helpers.role_path(self)}>#{self.name}</a>".html_safe
  end

  def note_truncate
    truncate(Loofah.fragment(self.note).text, length: 100)
  end

  def is_special?
    self.special == true
  end

  def is_not_special?
    self.special == false
  end

end
