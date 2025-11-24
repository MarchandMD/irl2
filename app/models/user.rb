class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :tasks
  has_many :upvotes, dependent: :destroy
  has_many :upvoted_tasks, through: :upvotes, source: :task
  has_many :user_tasks, dependent: :destroy
  has_many :completed_tasks, through: :user_tasks, source: :task
end
