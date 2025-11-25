class AddCommentsCountToTasksAndUserTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :comments_count, :integer, default: 0, null: false
    add_column :user_tasks, :comments_count, :integer, default: 0, null: false
    add_column :user_tasks, :upvotes_count, :integer, default: 0, null: false
  end
end
