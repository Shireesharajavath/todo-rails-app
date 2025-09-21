class ChangeEndAtNullOnTodoTimeLogs < ActiveRecord::Migration[7.0]
  def change
    change_column_null :todo_time_logs, :end_at, true
  end
end
