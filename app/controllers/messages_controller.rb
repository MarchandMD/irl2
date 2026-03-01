class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.new(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to channel_path(@channel) }
      end
    else
      redirect_to channel_path(@channel)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
