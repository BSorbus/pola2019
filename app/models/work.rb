class Work < ApplicationRecord
  include ActionView::Helpers::TextHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  belongs_to :trackable, polymorphic: true, optional: true
  belongs_to :user, optional: true

  def action_name
    case action
    when 'create'
      'utworzył kartotekę'
    when 'update'
      'zmodyfikował kartotekę'
    when 'destroy'
      'usunął kartotekę'
    else
      'Error action value !'
    end  
  end

  def link_to_trackable_url
    self.trackable ? "<a href=#{self.trackable_url}>#{truncate(self.trackable.fullname, length: 100)}</a>".html_safe : self.trackable_id
  end

  def pretty_parameters
    JSON.pretty_generate(JSON.parse(self.parameters.gsub('":"', '": "')))
  end

end
