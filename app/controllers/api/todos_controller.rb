# app/controllers/api/todos_controller.rb
module Api
  class TodosController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user

    # GET /api/todos
    def index
      todos = current_user.todos.order(created_at: :asc)
                          .page(params[:page] || 1)
                          .per(params[:per_page] || 10)

      render json: {
        success: true,
        todos: todos.as_json(only: [:id, :title, :description, :completed, :scheduled_time, :expected_completion, :priority, :status, :created_at, :updated_at]),
        pagination: {
          current_page: todos.current_page,
          next_page: todos.next_page,
          prev_page: todos.prev_page,
          total_pages: todos.total_pages,
          total_count: todos.total_count
        }
      }, status: :ok
    end

    private

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
end
