class Todo < ApplicationRecord
  belongs_to :user
  has_many :todo_time_logs, dependent: :destroy
end
