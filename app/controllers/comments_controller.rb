class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back fallback_location: root_path, notice: "Comment added successfully."
    else
      redirect_back fallback_location: root_path, alert: "Failed to add comment: #{@comment.errors.full_messages.join(", ")}"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.user == current_user || @comment.commentable.try(:user) == current_user
      @comment.destroy
      redirect_back fallback_location: root_path, notice: "Comment deleted successfully."
    else
      redirect_back fallback_location: root_path, alert: "Not authorized to delete this comment."
    end
  end

  private

  def set_commentable
    if params[:task_id]
      @commentable = Task.find(params[:task_id])
    elsif params[:submission_id]
      @commentable = UserTask.find(params[:submission_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
