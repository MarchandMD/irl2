class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true

  validates :content, presence: true

  default_scope { order(created_at: :asc) }
end
