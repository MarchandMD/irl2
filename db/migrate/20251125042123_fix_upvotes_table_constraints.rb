class FixUpvotesTableConstraints < ActiveRecord::Migration[8.0]
  def change
    # Make task_id nullable to support polymorphic upvotable
    change_column_null :upvotes, :task_id, true

    # Remove the old unique constraint
    remove_index :upvotes, name: "index_upvotes_on_user_id_and_task_id"

    # Add a new composite unique index that covers both task and polymorphic upvotable
    add_index :upvotes, [:user_id, :task_id, :upvotable_type, :upvotable_id],
              unique: true,
              name: "index_upvotes_on_user_and_votable"
  end
end
