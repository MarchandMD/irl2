class Upvote < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true, counter_cache: :upvotes_count
  belongs_to :upvotable, polymorphic: true, optional: true, counter_cache: true

  validates :user_id, uniqueness: {scope: [:task_id, :upvotable_type, :upvotable_id]}
  validate :has_upvotable_target

  private

  def has_upvotable_target
    if task_id.blank? && (upvotable_type.blank? || upvotable_id.blank?)
      errors.add(:base, "must belong to either a task or an upvotable")
    end
  end
end
