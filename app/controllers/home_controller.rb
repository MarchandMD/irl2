class HomeController < ApplicationController
  def index
    @recent_submissions = UserTask.where.not(submitted_at: nil)
      .order(submitted_at: :desc)
      .limit(5)
      .includes(:user, :task, submission_media_attachments: :blob)

    if user_signed_in?
      @recent_tasks = Task.active
        .order(created_at: :desc)
        .limit(5)
        .includes(:user)
    end
  end
end
