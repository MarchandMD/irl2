class TasksController < ApplicationController
  def index
    @tasks = Task.all

    # Calculate stats
    @active_tasks_count = Task.where(status: 'open').count
    @in_progress_count = Task.where(status: 'in_progress').count
    @completed_count = Task.where(status: 'completed').count
    @total_users_count = User.count
  end
end