require "rails_helper"

RSpec.describe Channel, type: :model do
  describe "validations" do
    context "when name is blank" do
      it "is not valid" do
        channel = build(:channel, name: "")
        expect(channel).not_to be_valid
        expect(channel.errors[:name]).to include("can't be blank")
      end
    end

    context "when name is duplicate" do
      it "is not valid" do
        create(:channel, name: "General")
        duplicate = build(:channel, name: "General")
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include("has already been taken")
      end
    end

    context "when name is present and unique" do
      it "is valid" do
        channel = build(:channel, name: "General")
        expect(channel).to be_valid
      end
    end
  end

  describe "associations" do
    it "has many messages" do
      assoc = described_class.reflect_on_association(:messages)
      expect(assoc.macro).to eq(:has_many)
    end

    it "destroys dependent messages" do
      channel = create(:channel)
      create(:message, channel: channel)
      expect { channel.destroy }.to change(Message, :count).by(-1)
    end
  end
end
