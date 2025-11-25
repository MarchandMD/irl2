class AddUpvotableToUpvotes < ActiveRecord::Migration[8.0]
  def change
    add_reference :upvotes, :upvotable, polymorphic: true, null: true
  end
end
