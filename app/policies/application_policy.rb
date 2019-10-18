class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    #raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  def event_activities(accesses_model)
    a = event_type_activities
    b = event_user_activities

    ab = []
    a.each do |str_a|
      if str_a.include? ':*'
        b.each do |str_b|
          if str_b.include? '*:'
            ab << "#{str_a.gsub(':*', '' )}:#{str_b.gsub('*:', '' )}" 
          else
            ab << str_b
          end
        end
      else
        ab << str_a
      end
    end
    return ab
  end

  def user_activities
    @user.roles.select(:activities).distinct.map(&:activities).flatten
  end

  def inferred_activity(method)
    "#{@record.class.name.downcase}:#{method.to_s}"
  end

  def method_missing(name,*args)
    if name.to_s.last == '?'
      user_activities.include?(inferred_activity(name.to_s.gsub('?','')))
    else
      super
    end
  end

end
