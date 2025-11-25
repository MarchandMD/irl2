class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:create]
  before_action :set_submission, only: [:upvote, :remove_upvote]

  def create
    @user_task = @task.user_tasks.find_or_initialize_by(user: current_user)

    if @user_task.persisted?
      redirect_to @task, alert: "Submission already exists for this task."
      return
    end

    @user_task.submission_text = submission_params[:submission_text]
    @user_task.submitted_at = Time.current
    @user_task.completed = true
    @user_task.submission_media.attach(submission_params[:submission_media]) if submission_params[:submission_media].present?

    if @user_task.save
      redirect_to @task, notice: "Submission created successfully."
    else
      redirect_to @task, alert: "Failed to create submission: #{@user_task.errors.full_messages.join(", ")}"
    end
  end

  def upvote
    upvote = @submission.upvotes.find_or_initialize_by(user: current_user)

    if upvote.persisted?
      redirect_back fallback_location: root_path, alert: "Already upvoted this submission."
    elsif upvote.save
      redirect_back fallback_location: root_path, notice: "Submission upvoted."
    else
      redirect_back fallback_location: root_path, alert: "Failed to upvote submission."
    end
  end

  def remove_upvote
    upvote = @submission.upvotes.find_by(user: current_user)

    if upvote
      upvote.destroy
      redirect_back fallback_location: root_path, notice: "Upvote removed."
    else
      redirect_back fallback_location: root_path, alert: "Upvote not found."
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_submission
    @submission = UserTask.find(params[:id])
  end

  def submission_params
    params.require(:user_task).permit(:submission_text, submission_media: [])
  end
end
