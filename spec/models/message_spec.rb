require "rails_helper"

RSpec.describe Message, type: :model do
  describe "validations" do
    context "when content is blank" do
      it "is not valid" do
        message = build(:message, content: "")
        expect(message).not_to be_valid
        expect(message.errors[:content]).to include("can't be blank")
      end
    end

    context "when content is present" do
      it "is valid" do
        message = build(:message)
        expect(message).to be_valid
      end
    end
  end

  describe "associations" do
    it "belongs to a user" do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to a channel" do
      assoc = described_class.reflect_on_association(:channel)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "broadcasting" do
    it "has a broadcast callback to the channel" do
      callbacks = Message._commit_callbacks.select { |cb| cb.filter.to_s.include?("broadcast") }
      expect(callbacks).not_to be_empty
    end
  end

  describe "ordering" do
    it "orders messages by created_at ascending" do
      channel = create(:channel)
      user = create(:user)
      older = create(:message, channel: channel, user: user, content: "First", created_at: 1.hour.ago)
      newer = create(:message, channel: channel, user: user, content: "Second", created_at: Time.current)

      expect(channel.messages).to eq([older, newer])
    end
  end
end
