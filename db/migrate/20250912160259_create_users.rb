class ApplicationController < ActionController::API
  before_action :authenticate_user

  attr_reader :current_user

  private

  def authenticate_user
    # Get API key from request headers
    api_key = request.headers["X-API-KEY"]

    # Find user by API key
    @current_user = User.find_by(api_key: api_key)

    # If not found, return unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
