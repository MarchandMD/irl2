module Admin
  class CommentsController < BaseController
    def index
      @comments = Comment.includes(:user, :commentable).order(created_at: :desc)
    end

    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
      redirect_to admin_comments_path, notice: "Comment deleted successfully."
    end
  end
end
