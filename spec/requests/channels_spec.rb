require "rails_helper"

RSpec.describe "Channels", type: :request do
  let(:user) { create(:user) }
  let!(:general_chat_channel) { create(:channel, name: "General") }

  describe "GET /channels" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get channels_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "redirects to the General channel" do
        get channels_path
        expect(response).to redirect_to(channel_path(general_chat_channel))
      end
    end
  end

  describe "GET /channels/:id" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get channel_path(general_chat_channel)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns a successful response" do
        get channel_path(general_chat_channel)
        expect(response).to have_http_status(:ok)
      end

      it "displays the channel name" do
        get channel_path(general_chat_channel)
        expect(response.body).to include("General")
      end

      it "displays existing messages" do
        create(:message, channel: general_chat_channel, user: user, content: "Hello everyone!")
        get channel_path(general_chat_channel)
        expect(response.body).to include("Hello everyone!")
      end
    end
  end
end
