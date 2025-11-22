class AddDetailsToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :title, :string
    add_column :tasks, :description, :text
    add_column :tasks, :status, :string, default: "open"
    add_reference :tasks, :user, null: false, foreign_key: true
    add_column :tasks, :upvotes_count, :integer, default: 0
    add_column :tasks, :submissions_count, :integer, default: 0
  end
end
