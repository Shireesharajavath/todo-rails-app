class ChangeDurationSecondsNullableInTodoTimeLogs < ActiveRecord::Migration[8.0]
  def change
    change_column_null :todo_time_logs, :duration_seconds, true
  end
end
