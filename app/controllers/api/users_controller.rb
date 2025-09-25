# app/controllers/api/users_controller.rb
module Api
  class UsersController < ApplicationController
    # API endpoints don’t use session auth or CSRF
    skip_before_action :authenticate_user, only: [:signup, :login, :get_api_key,:index]
    skip_before_action :verify_authenticity_token, only: [:signup, :login, :get_api_key, :me, :index]

    # POST /api/signup
    def signup
      user = User.new(user_params)
      user.api_key = SecureRandom.hex(32)

      if user.save
        render json: {
          success: true,
          message: "User created successfully",
          user: user.slice(:id, :name, :email, :api_key)
        }, status: :created
      else
        render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # POST /api/login
    def login
      user = User.find_by(email: params[:email].to_s.downcase.strip)
      if user&.authenticate(params[:password])
        render json: {
          success: true,
          message: "Login successful",
          api_key: user.api_key
        }, status: :ok
      else
        render json: { success: false, error: "Invalid email or password" }, status: :unauthorized
      end
    end

    # POST /api/get_api_key
    def get_api_key
      email = params[:email].to_s.downcase.strip.presence
      return render json: { success: false, error: "Email is required" }, status: :bad_request if email.blank?

      user = User.find_by(email: email)
      return render json: { success: false, error: "User not found" }, status: :not_found unless user

      user.update!(api_key: SecureRandom.hex(32)) if user.api_key.blank?

      render json: {
        success: true,
        user: user.slice(:id, :name, :email, :api_key, :created_at, :updated_at)
      }, status: :ok
    rescue StandardError => e
      render json: { success: false, error: e.message }, status: :internal_server_error
    end

    # GET /api/me
    def me
      render json: {
        success: true,
        user: current_user.slice(:id, :name, :email, :api_key)
      }, status: :ok
    end

    # GET /api/users
    def index
      users = User.all.select(:id, :name, :email, :created_at, :updated_at)
      render json: {
        success: true,
        users: users
      }, status: :ok
    end

    private

    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
