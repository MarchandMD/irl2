class TasksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

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

    # Calculate stats
    @active_tasks_count = Task.where(status: "open").count
    @in_progress_count = Task.where(status: "in_progress").count
    @completed_count = Task.where(status: "completed").count
    @total_users_count = User.count
  end

  def show
    @task = Task.find(params[:id])
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

  def task_params
    params.require(:task).permit(:title, :description, :status, :recommended_group)
  end
end
