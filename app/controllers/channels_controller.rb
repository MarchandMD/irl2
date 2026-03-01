class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def index
    general = Channel.find_by!(name: "General")
    redirect_to channel_path(general)
  end

  def show
    @channel = Channel.find(params[:id])
    @messages = @channel.messages.includes(:user)
    @message = Message.new
  end
end
