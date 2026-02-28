module Admin
  class TasksController < BaseController
    before_action :set_task, only: [:show, :edit, :update, :destroy]

    def index
      @tasks = Task.includes(:user).order(created_at: :desc)
      @tasks = @tasks.search(params[:search]) if params[:search].present?
      @tasks = @tasks.where(status: params[:status]) if params[:status].present?
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
      @task.destroy
      redirect_to admin_tasks_path, notice: "Task deleted successfully."
    end

    def destroy_all
      Task.destroy_all
      redirect_to admin_tasks_path, notice: "All tasks deleted successfully."
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
