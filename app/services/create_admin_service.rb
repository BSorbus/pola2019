class CreateAdminService
  def call
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.name = Rails.application.secrets.admin_name
        user.note = 'Wbudowane konto Administratora Głównego'
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        #user.admin!
      end
  end

  def call_simple(email, name, pass, note)
    user = User.find_or_create_by!(email: "#{email}".downcase) do |user|
        user.name = "#{name}"
        user.password = "#{pass}"
        user.password_confirmation = "#{pass}"
        user.note = "#{note}"
        #user.admin!
      end
  end

end
