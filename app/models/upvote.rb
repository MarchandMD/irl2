class Upvote < ApplicationRecord
  belongs_to :user
  belongs_to :task, counter_cache: :upvotes_count

  validates :user_id, uniqueness: {scope: :task_id}
end
