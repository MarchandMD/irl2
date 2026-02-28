module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_tasks = Task.count
      @total_comments = Comment.count
      @total_submissions = UserTask.count
      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_tasks = Task.includes(:user).order(created_at: :desc).limit(5)
      @recent_comments = Comment.includes(:user).order(created_at: :desc).limit(5)
    end
  end
end
