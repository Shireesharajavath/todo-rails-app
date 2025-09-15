class AddExtraFieldsToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :scheduled_time, :datetime unless column_exists?(:todos, :scheduled_time)
    add_column :todos, :expected_completion, :datetime unless column_exists?(:todos, :expected_completion)
    add_column :todos, :priority, :string unless column_exists?(:todos, :priority)
    add_column :todos, :status, :string unless column_exists?(:todos, :status)
    add_column :todos, :assigned_to, :string unless column_exists?(:todos, :assigned_to)
    add_column :todos, :notes, :text unless column_exists?(:todos, :notes)
    add_column :todos, :tags, :string unless column_exists?(:todos, :tags)
  end
end
