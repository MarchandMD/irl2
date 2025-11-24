class TasksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :upvote, :remove_upvote]
  before_action :set_task, only: [:show, :upvote, :remove_upvote]

  def index
    @tasks = Task.includes(:user).all

    # Search filter
    if params[:q].present?
      @tasks = @tasks.search(params[:q])
    end

    # Filter by group if group parameter is present
    if params[:group].present?
      @tasks = @tasks.joins(:user).where(users: {group: params[:group]})
    end

    # Filter by status
    if params[:status].present? && params[:status] != "all"
      @tasks = @tasks.where(status: params[:status])
    end

    # Sort tasks
    @tasks = case params[:sort]
    when "popular"
      @tasks.order(upvotes_count: :desc, created_at: :desc)
    when "active"
      @tasks.order(submissions_count: :desc, created_at: :desc)
    else # 'newest' or nil
      @tasks.order(created_at: :desc)
    end

    # Calculate stats
    @total_tasks_count = Task.count
    @bookmarked_count = Task.where(status: "bookmarked").count
    @completed_count = current_user&.completed_tasks&.count || 0
    @total_users_count = User.count

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "tasks_list" }
    end
  end

  def show
  end

  def upvote
    unless @task.upvoted_by?(current_user)
      @task.upvotes.create(user: current_user)
    end
    redirect_to @task
  end

  def remove_upvote
    upvote = @task.upvotes.find_by(user: current_user)
    upvote&.destroy
    redirect_to @task
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    @task.status ||= "open"
    @task.upvotes_count ||= 0
    @task.submissions_count ||= 0

    if @task.save
      redirect_to task_path(@task), notice: "Task created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :recommended_group)
  end
end
