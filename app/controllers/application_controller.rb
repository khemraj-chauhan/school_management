class ApplicationController < ActionController::Base
  include ApplicationMethods

  protect_from_forgery unless: -> { request.format.json? }

  before_action :set_current_user, if: -> { request.format.json? }
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  after_action :clear_current_user, if: -> { request.format.json? }

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone name])
  end

  def validate_super_admin!
    return if current_user.has_role?("admin")

    respond_to do |format|
      format.html { redirect_to root_path, alert: "You are not authorize user" }
      format.json { render json: {data: [], error: "You are not authorize user"}, status: 401 }
    end
  end

  def validate_admin!
    return if current_user.has_any_role?(["admin", "school_admin"])

    respond_to do |format|
      format.html { redirect_to root_path, alert: "You are not authorize user" }
      format.json { render json: {data: [], error: "You are not authorize user"}, status: 401 }
    end
  end

  def set_current_user
    email, password = Base64.decode64(request.headers["Authorization"].split[1]).split(":") rescue nil
    user = User.find_by_email(email)
    sign_in(:user, user) if user.valid_password?(password)
  end

  def clear_current_user
    sign_out(current_user)
  end
end
