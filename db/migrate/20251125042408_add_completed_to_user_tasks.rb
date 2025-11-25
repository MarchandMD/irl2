class AddCompletedToUserTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :user_tasks, :completed, :boolean, default: false, null: false
  end
end
