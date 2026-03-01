class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: [:google_oauth2]

  has_one_attached :profile_photo

  has_many :tasks, dependent: :destroy
  has_many :upvotes, dependent: :destroy
  has_many :upvoted_tasks, through: :upvotes, source: :task
  has_many :user_tasks, dependent: :destroy
  has_many :completed_tasks, through: :user_tasks, source: :task
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_tasks, through: :bookmarks, source: :task
  has_many :comments, dependent: :destroy

  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  validate :acceptable_profile_photo

  def archived?
    archived_at.present?
  end

  def archive!
    update!(archived_at: Time.current)
  end

  def unarchive!
    update!(archived_at: nil)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def password_required?
    provider.blank? && super
  end

  private

  def acceptable_profile_photo
    return unless profile_photo.attached?

    acceptable_types = ["image/png", "image/jpg", "image/jpeg", "image/gif", "image/webp"]
    unless acceptable_types.include?(profile_photo.content_type)
      errors.add(:profile_photo, "must be a PNG, JPG, GIF, or WebP")
    end

    if profile_photo.byte_size > 5.megabytes
      errors.add(:profile_photo, "must be less than 5MB")
    end
  end
end
