class CreateTodoTimeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :todo_time_logs do |t|
      t.integer :todo_id, null: false, index: true
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.integer :duration_seconds, null: false
      t.timestamps
    end
    add_column :todos, :time_spent_seconds, :integer, default: 0 unless column_exists?(:todos, :time_spent_seconds)
    add_foreign_key :todo_time_logs, :todos, column: :todo_id
  end
end
