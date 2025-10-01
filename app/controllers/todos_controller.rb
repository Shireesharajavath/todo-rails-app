class TodosController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /api/todos
  def index
    todos = current_user.todos
                        .order(created_at: :desc) # newest first
                        .page(params[:page])
                        .per(params[:per_page] || 8)

    render json: {
      todos: todos,
      pagination: {
        total_count: todos.total_count,
        current_page: todos.current_page,
        per_page: todos.limit_value
      }
    }
  end

  # GET /api/todos/:id
  def show
    render json: @todo
  end

  # POST /api/todos
  def create
    todo = current_user.todos.new(todo_params)
    if todo.save
      render json: { message: "Todo created successfully", todo: todo }, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /api/todos/:id
  def update
    if @todo.update(todo_params)
      render json: { message: "Todo updated successfully", todo: @todo }, status: :ok
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/todos/:id
  def destroy
    if @todo
      @todo.destroy
      render json: { message: "Todo deleted successfully" }, status: :ok
    else
      render json: { error: "Todo not found or unauthorized" }, status: :not_found
    end
  end

  private

  def set_todo
    @todo = current_user.todos.find_by(id: params[:id])
    unless @todo
      render json: { error: "Todo not found or unauthorized" }, status: :not_found
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

    if auth_header.present? && auth_header =~ /\ABearer\s+(.+)\z/i
      token = Regexp.last_match(1)
      @current_user = User.find_by(api_key: token)
    end

    unless @current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
