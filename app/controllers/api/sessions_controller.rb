module Api
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: [:create]
    skip_before_action :verify_authenticity_token, only: [:create]

    # POST /api/login
    def create
      email = params[:email].to_s.downcase.strip
      password = params[:password]

      user = User.find_by(email: email)

      if user&.authenticate(password)
        render json: { success: true, message: "Login successful", api_key: user.api_key }, status: :ok
      else
        render json: { success: false, error: "Invalid email or password" }, status: :unauthorized
      end
    end

    # DELETE /api/logout
    def destroy
      render json: { success: true, message: "Logged out" }, status: :ok
    end
  end
end
