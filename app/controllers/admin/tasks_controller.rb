module Admin
  class TasksController < BaseController
    before_action :set_task, only: [:show, :edit, :update, :destroy, :unarchive]

    def index
      @tasks = Task.includes(:user).order(created_at: :desc)
      @tasks = @tasks.search(params[:search]) if params[:search].present?
      @tasks = @tasks.where(status: params[:status]) if params[:status].present?

      if params[:filter] == "archived"
        @tasks = @tasks.archived
      else
        @tasks = @tasks.active
      end
    end

    def show
    end

    def edit
    end

    def update
      if @task.update(task_params)
        redirect_to admin_task_path(@task), notice: "Task updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @task.archive!
      redirect_to admin_tasks_path, notice: "Task archived successfully."
    end

    def unarchive
      @task.unarchive!
      redirect_to admin_tasks_path(filter: "archived"), notice: "Task unarchived successfully."
    end

    def bulk_archive
      task_ids = params[:task_ids]&.reject(&:blank?) || []
      tasks = Task.where(id: task_ids)
      archived_count = 0
      tasks.each do |task|
        task.archive!
        archived_count += 1
      end
      redirect_to admin_tasks_path, notice: "#{archived_count} task(s) archived successfully."
    end

    def archive_all
      Task.active.find_each(&:archive!)
      redirect_to admin_tasks_path, notice: "All tasks archived successfully."
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :status, :recommended_group)
    end
  end
end
