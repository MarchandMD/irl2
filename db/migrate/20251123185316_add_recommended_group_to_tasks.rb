class AddRecommendedGroupToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :recommended_group, :string
  end
end
