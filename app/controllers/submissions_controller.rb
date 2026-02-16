class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:create, :edit, :update]
  before_action :set_submission, only: [:edit, :update, :upvote, :remove_upvote]
  before_action :authorize_submission_owner, only: [:edit, :update]

  def index
    @submissions = UserTask.includes(:user, :task).order(created_at: :desc)
  end

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

  def edit
    # @task and @submission are set by before_action
  end

  def update
    # Remove media marked for deletion
    if params[:user_task] && params[:user_task][:remove_media_ids].present?
      media_ids = params[:user_task][:remove_media_ids].reject(&:blank?)
      media_ids.each do |media_id|
        attachment = @submission.submission_media.find(media_id)
        attachment.purge
      rescue ActiveRecord::RecordNotFound
        # Media already deleted or doesn't exist
        next
      end
    end

    # Update submission text
    @submission.assign_attributes(submission_text: submission_params[:submission_text])

    # Attach new media if provided
    if submission_params[:submission_media].present?
      @submission.submission_media.attach(submission_params[:submission_media])
    end

    if @submission.save
      redirect_to @task, notice: "Submission updated successfully."
    else
      render :edit, status: :unprocessable_entity
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

  def authorize_submission_owner
    unless @submission.user == current_user
      redirect_to @task, alert: "Not authorized to edit this submission."
    end
  end

  def submission_params
    params.require(:user_task).permit(:submission_text, submission_media: [])
  end
end
