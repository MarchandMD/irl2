class CreateBookmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end

    add_index :bookmarks, [:user_id, :task_id], unique: true
    add_column :tasks, :bookmarks_count, :integer, default: 0, null: false
  end
end
