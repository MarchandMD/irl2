class UserTask < ApplicationRecord
  belongs_to :user
  belongs_to :task, counter_cache: :submissions_count

  has_many_attached :submission_media
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :upvotes, as: :upvotable, dependent: :destroy
  has_many :upvoters, through: :upvotes, source: :user

  validates :user_id, uniqueness: {scope: :task_id}
  validate :submission_content_present
  validate :acceptable_submission_media

  def upvoted_by?(user)
    return false unless user
    upvotes.exists?(user_id: user.id)
  end

  private

  def submission_content_present
    if submission_text.blank? && !submission_media.attached?
      errors.add(:base, "must include either text or media")
    end
  end

  def acceptable_submission_media
    return unless submission_media.attached?

    acceptable_image_types = ["image/png", "image/jpg", "image/jpeg", "image/gif", "image/webp"]
    acceptable_video_types = ["video/mp4", "video/quicktime", "video/x-msvideo"]

    submission_media.each do |media|
      unless acceptable_image_types.include?(media.content_type) || acceptable_video_types.include?(media.content_type)
        errors.add(:submission_media, "must be PNG, JPG, GIF, WebP, MP4, MOV, or AVI")
        break
      end

      if acceptable_image_types.include?(media.content_type) && media.byte_size > 5.megabytes
        errors.add(:submission_media, "images must be less than 5MB")
        break
      end

      if acceptable_video_types.include?(media.content_type) && media.byte_size > 50.megabytes
        errors.add(:submission_media, "videos must be less than 50MB")
        break
      end
    end
  end
end
