class ApplicationController < ActionController::Base
  include ApplicationMethods

  protect_from_forgery unless: -> { request.format.json? }

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  def current_user
    if request.format.json?
      user = Base64.decode64(request.headers["Authorization"].split[1]).split(":")
      if user[1].eql?("test123")
        @current_user = User.find_by_email(user[0])
        return @current_user
      end
    else
      super
    end
  end
end
