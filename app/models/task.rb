class Task < ApplicationRecord
  belongs_to :user
  has_many :upvotes, dependent: :destroy
  has_many :upvoters, through: :upvotes, source: :user

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

    joins(:user).where(
      "tasks.title ILIKE ? OR tasks.description ILIKE ? OR users.email ILIKE ?",
      "%#{sanitize_sql_like(query)}%",
      "%#{sanitize_sql_like(query)}%",
      "%#{sanitize_sql_like(query)}%"
    )
  }

  def upvoted_by?(user)
    return false unless user
    upvotes.exists?(user_id: user.id)
  end
end
