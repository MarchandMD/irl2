class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc)
    @groups = User.distinct.pluck(:group).compact.sort
  end
end
