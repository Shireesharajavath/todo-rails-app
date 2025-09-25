class ApplicationController < ActionController::Base
  # Make these methods available in views
  helper_method :current_user, :logged_in?

  # Protect web forms from CSRF, skip for API JSON requests
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  # Authenticate API requests only for JSON endpoints
  before_action :authenticate_user, if: :json_request?

  private

  # Detect JSON requests reliably
  def json_request?
    request.format.json? || request.content_type == 'application/json'
  end

  # Returns current user (session for web, API key for JSON)
  def current_user
    return @current_user if @current_user

    # Session-based authentication for web pages
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]

    # API key-based authentication is set in authenticate_user
    @current_user
  end

  # Boolean: is user logged in?
  def logged_in?
    !!current_user
  end

  # Require login for web pages
  def require_login
    redirect_to login_path, alert: "You must be logged in" unless logged_in?
  end

  # Authenticate API requests using Bearer token
  def authenticate_user
    return if @current_user.present? # already authenticated via session

    auth_header = request.headers['Authorization']
    if auth_header.present? && auth_header =~ /^Bearer (.+)$/
      token = Regexp.last_match(1)
      @current_user = User.find_by(api_key: token)
    end

    render json: { success: false, error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
