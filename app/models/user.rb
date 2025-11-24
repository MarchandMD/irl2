class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_one_attached :profile_photo

  has_many :tasks
  has_many :upvotes, dependent: :destroy
  has_many :upvoted_tasks, through: :upvotes, source: :task
  has_many :user_tasks, dependent: :destroy
  has_many :completed_tasks, through: :user_tasks, source: :task
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_tasks, through: :bookmarks, source: :task

  validate :acceptable_profile_photo

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
