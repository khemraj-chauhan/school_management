class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone name])
  end

  def validate_admin!
    return if current_user.has_role?("admin")

    respond_to do |format|
      format.html { redirect_to root_path, alert: "You are not authorize user" }
      format.json { head :no_content }
    end
  end
end
