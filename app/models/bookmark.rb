class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :task, counter_cache: :bookmarks_count

  validates :user_id, uniqueness: {scope: :task_id}
end
