class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc)

    # Filter by group if group parameter is present
    if params[:group].present?
      @users = @users.where(group: params[:group])
    end

    @groups = User.distinct.pluck(:group).compact.sort
  end
end
