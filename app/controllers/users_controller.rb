# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # Allow API/Postman calls without a CSRF token for this endpoint
  skip_before_action :verify_authenticity_token, only: [:get_api_key]

  # Skip Devise / other authentication filters just for this action
  skip_before_action :authenticate_user!, only: [:get_api_key], raise: false if defined?(Devise)
  skip_before_action :require_login,    only: [:get_api_key], raise: false
  skip_before_action :authorize,        only: [:get_api_key], raise: false
  skip_before_action :ensure_logged_in, only: [:get_api_key], raise: false
  skip_before_action :authenticate,     only: [:get_api_key], raise: false

  # POST /get_api_key
  # Body: { "email": "alice@example.com" }
  def get_api_key
    email = params[:email].to_s.downcase.strip.presence || params.dig(:user, :email).to_s.downcase.strip.presence

    if email.blank?
      return render json: { success: false, error: "email is required" }, status: :bad_request
    end

    user = User.find_by(email: email)
    unless user
      return render json: { success: false, error: "User not found" }, status: :not_found
    end

    # Generate an API key if missing
    if user.api_key.blank?
      user.update!(api_key: SecureRandom.hex(32))
    end

    render json: {
      success: true,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        api_key: user.api_key,
        created_at: user.created_at,
        updated_at: user.updated_at
      }
    }, status: :ok
  end

  # GET /users/:id
  def show
    user = User.find(params[:id])
    render json: { success: true, user: user }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "User not found" }, status: :not_found
  end

  # GET /signup
  def new
    @user = User.new
  end

  # POST /signup
  def create
    @user = User.new(user_params)
    @user.api_key = SecureRandom.hex(32) # generate new api_key

    if @user.save
      session[:user_id] = @user.id
      redirect_to todos_path, notice: "Account created successfully"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
