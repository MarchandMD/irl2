class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc)

    # Filter by group if group parameter is present
    if params[:group].present?
      @users = @users.where(group: params[:group])
    end

    @groups = User.distinct.pluck(:group).compact.sort
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.order(created_at: :desc)
    @completed_tasks = @tasks.where(status: "completed")
    @in_progress_tasks = @tasks.where(status: "in_progress")
    @open_tasks = @tasks.where(status: "open")
    @bookmarked_tasks = @user.bookmarked_tasks.order(created_at: :desc)
  end
end
