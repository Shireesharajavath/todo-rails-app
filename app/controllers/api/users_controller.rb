module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_user, only: [:signup, :login, :get_api_key, :index, :create, :show, :logout, :get_profile, :update_profile]
    skip_before_action :verify_authenticity_token, only: [:signup, :login, :get_api_key, :me, :index, :create, :show, :logout, :get_profile, :update_profile]

    # 🔹 Signup
    def signup
      user = User.new(user_params)
      user.api_key = SecureRandom.hex(32)

      if user.save
        render json: {
          success: true,
          message: "User created successfully",
          user: user.slice(:id, :name, :email, :api_key, :photo_url)
        }, status: :created
      else
        render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # 🔹 Login
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

    # 🔹 Get API Key
    def get_api_key
      email = params[:email].to_s.downcase.strip.presence
      return render json: { success: false, error: "Email is required" }, status: :bad_request if email.blank?

      user = User.find_by(email: email)
      return render json: { success: false, error: "User not found" }, status: :not_found unless user

      user.update!(api_key: SecureRandom.hex(32)) if user.api_key.blank?

      render json: {
        success: true,
        user: user.slice(:id, :name, :email, :api_key, :photo_url, :created_at, :updated_at)
      }, status: :ok
    rescue StandardError => e
      render json: { success: false, error: e.message }, status: :internal_server_error
    end

    # 🔹 Current User (me)
    def me
      render json: {
        success: true,
        user: current_user.slice(:id, :name, :email, :api_key, :photo_url)
      }, status: :ok
    end

    # 🔹 List Users (paginated)
    def index
      users = User.order(created_at: :desc)
                  .page(params[:page] || 1)
                  .per(params[:per_page] || 10)

      render json: {
        success: true,
        users: users.as_json(only: [:id, :name, :email, :photo_url, :created_at, :updated_at]),
        pagination: {
          current_page: users.current_page,
          next_page: users.next_page,
          prev_page: users.prev_page,
          total_pages: users.total_pages,
          total_count: users.total_count
        }
      }, status: :ok
    end

    # 🔹 Create User (admin style)
    def create
      user = User.new(user_params)
      user.api_key ||= SecureRandom.hex(32)

      if user.save
        render json: {
          success: true,
          message: "User created successfully",
          user: user.slice(:id, :name, :email, :api_key, :photo_url)
        }, status: :created
      else
        render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # 🔹 Show User
    def show
      user = User.find_by(id: params[:id])
      if user
        render json: {
          success: true,
          user: user.slice(:id, :name, :email, :api_key, :photo_url, :created_at, :updated_at)
        }, status: :ok
      else
        render json: { success: false, error: "User not found" }, status: :not_found
      end
    end

    # 🔹 Logout
    def logout
      reset_session
      render json: { success: true, message: "Logout successful" }, status: :ok
    end

    # 🔹 Get Profile (by API Key)
    def get_profile
      user = User.find_by(api_key: params[:api_key])

      if user
        render json: {
          success: true,
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
            photo_url: user.photo_url || "https://example.com/default.png"
          }
        }, status: :ok
      else
        render json: { success: false, error: "Invalid API key" }, status: :unauthorized
      end
    end

    # 🔹 Update Profile (by API Key)
    def update_profile
      user = User.find_by(api_key: params[:api_key])

      if user
        if user.update(name: params[:name], photo_url: params[:photo_url])
          render json: { success: true, message: "Profile updated successfully", user: user.slice(:id, :name, :email, :photo_url) }, status: :ok
        else
          render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { success: false, error: "Invalid API key" }, status: :unauthorized
      end
    end

    private

    def user_params
      params.permit(:name, :email, :password, :password_confirmation, :photo_url)
    end
  end
end
