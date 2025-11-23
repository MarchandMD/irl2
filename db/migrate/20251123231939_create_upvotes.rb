class CreateUpvotes < ActiveRecord::Migration[8.0]
  def change
    create_table :upvotes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end

    add_index :upvotes, [:user_id, :task_id], unique: true
  end
end
