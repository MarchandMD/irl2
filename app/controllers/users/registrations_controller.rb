class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def remove_profile_photo
    if current_user.profile_photo.attached?
      current_user.profile_photo.purge
      redirect_to edit_user_registration_path, notice: "Profile photo removed successfully."
    else
      redirect_to edit_user_registration_path, alert: "No profile photo to remove."
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:profile_photo])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile_photo])
  end
end
