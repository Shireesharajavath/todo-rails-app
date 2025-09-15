
class ApplicationController < ActionController::Base
  
  helper_method :current_user, :logged_in?

  
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  before_action :authenticate_user, if: -> { request.format.json? }

  private

  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def require_login
    redirect_to login_path, alert: "You must be logged in" unless logged_in?
  end

 
  def authenticate_user
    auth_header = request.headers["Authorization"]

    if auth_header.present? && auth_header =~ /^Token token=(.+)$/
      token = Regexp.last_match(1)
      @current_user = User.find_by(api_key: token)
    end

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
