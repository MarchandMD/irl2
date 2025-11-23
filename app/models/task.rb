class Task < ApplicationRecord
  belongs_to :user

  GROUPS = [
    "Urban Nomads",
    "Digital Alchemists",
    "Street Philosophers",
    "Midnight Architects",
    "Concrete Poets"
  ].freeze

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :recommended_group, inclusion: {in: GROUPS, allow_nil: true}

  # Search scope
  scope :search, ->(query) {
    return all if query.blank?

    where("title ILIKE ? OR description ILIKE ?", "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%")
  }
end
