class TodoTimeLogsController < ApplicationController
  skip_before_action :verify_authenticity_token   # Allows API calls from Postman

  def start
    todo = Todo.find(params[:todo_id])            # Find the Todo by ID
    log = todo.todo_time_logs.create!(            # Create a new time log
      start_at: Time.current
    )
    render json: { success: true, log_id: log.id } # Respond with new log ID
  end

  def stop
    log = TodoTimeLog.where(todo_id: params[:todo_id], end_at: nil).last
    if log
      log.update!(
        end_at: Time.current,
        duration_seconds: (Time.current - log.start_at).to_i
      )
      render json: log
    else
      render json: { error: "No running timer" }, status: :not_found
    end
  end
end
