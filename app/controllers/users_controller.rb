class UsersController < ApplicationController
  
  skip_before_action :authenticate_user, only: [:get_api_key]
  skip_before_action :verify_authenticity_token, only: [:get_api_key]

  
  def get_api_key
    email = params[:email].to_s.downcase.strip.presence
    return render json: { success: false, error: "email is required" }, status: :bad_request if email.blank?

    user = User.find_by(email: email)
    return render json: { success: false, error: "User not found" }, status: :not_found unless user

 
    user.update!(api_key: SecureRandom.hex(32)) if user.api_key.blank?

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
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :internal_server_error
  end

 
  def show
    user = User.find(params[:id])
    render json: { success: true, user: user }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "User not found" }, status: :not_found
  end

 
  def new
    @user = User.new
  end

  
  def create
    @user = User.new(user_params)
    @user.api_key = SecureRandom.hex(32)

    if @user.save
      session[:user_id] = @user.id
      redirect_to todos_path, notice: "Account created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
