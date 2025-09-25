class SessionsController < ApplicationController
  # Skip API authentication & CSRF for login
  skip_before_action :authenticate_user, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]

  # POST /login (API only)
  def create
    email = params[:email].to_s.downcase.strip
    password = params[:password]

    user = User.find_by(email: email)

    if user&.authenticate(password)
      render json: {
        success: true,
        message: "Login successful",
        api_key: user.api_key
      }, status: :ok
    else
      render json: { success: false, error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # DELETE /logout (API only, optional)
  def destroy
    # API lo session use cheyyam → just dummy response
    render json: { success: true, message: "Logged out" }, status: :ok
  end
end
