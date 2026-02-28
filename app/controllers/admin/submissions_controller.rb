module Admin
  class SubmissionsController < BaseController
    def index
      @submissions = UserTask.includes(:user, :task).order(created_at: :desc)
    end

    def show
      @submission = UserTask.find(params[:id])
    end

    def destroy
      @submission = UserTask.find(params[:id])
      @submission.destroy
      redirect_to admin_submissions_path, notice: "Submission deleted successfully."
    end
  end
end
