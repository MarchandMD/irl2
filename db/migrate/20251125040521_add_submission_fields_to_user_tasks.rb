class AddSubmissionFieldsToUserTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :user_tasks, :submission_text, :text
    add_column :user_tasks, :submitted_at, :datetime
  end
end
