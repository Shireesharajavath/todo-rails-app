
class TodosController < ApplicationController
  before_action :authenticate_user
  before_action :set_todo, only: [:show, :edit, :update, :destroy]

  def index
    @todos = current_user.todos
    respond_to do |format|
      format.html
      format.json { render json: @todos }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @todo }
    end
  end

  def new
    @todo = current_user.todos.new
  end

  def create
    @todo = current_user.todos.new(todo_params)
    if @todo.save
      respond_to do |format|
        format.html { redirect_to todos_path, notice: "Todo created successfully." }
        format.json { render json: @todo, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      respond_to do |format|
        format.html { redirect_to todos_path, notice: "Todo updated successfully." }
        format.json { render json: @todo }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_path, notice: "Todo deleted." }
      format.json { head :no_content }
    end
  end

  private

  def set_todo
    @todo = current_user.todos.find_by(id: params[:id])
    unless @todo
      respond_to do |format|
        format.html { redirect_to todos_path, alert: "Todo not found or unauthorized." }
        format.json { render json: { error: "Todo not found or unauthorized" }, status: :unauthorized }
      end
    end
  end

  def todo_params
    params.require(:todo).permit(
      :title,
      :description,
      :completed,
      :scheduled_time,
      :expected_completion,
      :priority,
      :status
    )
  end


  def authenticate_user
    auth_header = request.headers["Authorization"]
    puts auth_header
    if auth_header.present? && auth_header =~ /^Token token=(.+)$/
      token = Regexp.last_match(1)
      @current_user = User.find_by(api_key: token)
    elsif session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end

    unless @current_user
      respond_to do |format|
        format.html { redirect_to login_path, alert: "You must be logged in." }
        format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
      end
    end
  end

  def current_user
    @current_user
  end
end
