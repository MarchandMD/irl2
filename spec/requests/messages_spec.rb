require "rails_helper"

RSpec.describe "Messages", type: :request do
  let(:user) { create(:user) }
  let!(:general_channel) { create(:channel, name: "General") }

  describe "POST /channels/:channel_id/messages" do
    context "when not authenticated" do
      it "redirects to sign in" do
        post channel_messages_path(general_channel), params: { message: { content: "Hello" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      context "with valid content" do
        it "creates a new message" do
          expect {
            post channel_messages_path(general_channel), params: { message: { content: "Hello world!" } }
          }.to change(Message, :count).by(1)
        end

        it "associates the message with the current user" do
          post channel_messages_path(general_channel), params: { message: { content: "Hello world!" } }
          expect(Message.last.user).to eq(user)
        end

        it "associates the message with the channel" do
          post channel_messages_path(general_channel), params: { message: { content: "Hello world!" } }
          expect(Message.last.channel).to eq(general_channel)
        end

        it "responds with a turbo stream" do
          post channel_messages_path(general_channel),
            params: { message: { content: "Hello world!" } },
            headers: { "Accept" => "text/vnd.turbo-stream.html" }
          expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        end
      end

      context "with blank content" do
        it "does not create a message" do
          expect {
            post channel_messages_path(general_channel), params: { message: { content: "" } }
          }.not_to change(Message, :count)
        end
      end
    end
  end
end
