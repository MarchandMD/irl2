module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :unarchive]

    def index
      @users = User.order(created_at: :desc)
      @users = @users.where("email ILIKE ?", "%#{params[:search]}%") if params[:search].present?
      if params[:filter] == "archived"
        @users = @users.archived
      else
        @users = @users.active
      end
    end

    def show
      @tasks = @user.tasks.order(created_at: :desc)
      @comments = @user.comments.order(created_at: :desc).limit(10)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "User updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "You cannot archive yourself."
        return
      end
      @user.archive!
      redirect_to admin_users_path, notice: "User archived successfully."
    end

    def unarchive
      @user.unarchive!
      redirect_to admin_users_path, notice: "User unarchived successfully."
    end

    def bulk_archive
      user_ids = params[:user_ids]&.reject(&:blank?) || []
      if user_ids.empty?
        redirect_to admin_users_path, alert: "No users selected."
        return
      end

      users = User.where(id: user_ids).where.not(id: current_user.id)
      archived_count = 0
      users.find_each do |user|
        user.archive!
        archived_count += 1
      end

      redirect_to admin_users_path, notice: "#{archived_count} #{'user'.pluralize(archived_count)} archived successfully."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:group, :admin)
    end
  end
end
