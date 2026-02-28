class Task < ApplicationRecord
  belongs_to :user
  has_many :upvotes, dependent: :destroy
  has_many :upvoters, through: :upvotes, source: :user
  has_many :user_tasks, dependent: :destroy
  has_many :completers, through: :user_tasks, source: :user
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarkers, through: :bookmarks, source: :user
  has_many :comments, as: :commentable, dependent: :destroy

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

  # Scopes
  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }
  scope :search, ->(query) {
    return all if query.blank?

    joins(:user).where(
      "tasks.title ILIKE ? OR tasks.description ILIKE ? OR users.email ILIKE ?",
      "%#{sanitize_sql_like(query)}%",
      "%#{sanitize_sql_like(query)}%",
      "%#{sanitize_sql_like(query)}%"
    )
  }

  def archived?
    archived_at.present?
  end

  def archive!
    update!(archived_at: Time.current)
  end

  def unarchive!
    update!(archived_at: nil)
  end

  def upvoted_by?(user)
    return false unless user
    upvotes.exists?(user_id: user.id)
  end

  def bookmarked_by?(user)
    return false unless user
    bookmarks.exists?(user_id: user.id)
  end
end
