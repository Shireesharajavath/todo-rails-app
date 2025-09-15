class AddScheduleToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :scheduled_time, :datetime
    add_column :todos, :expected_completion, :datetime
  end
end
