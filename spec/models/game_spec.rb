require "rails_helper"

RSpec.describe Game do
  describe "player_name" do
    subject(:game) { described_class.new(start_time: Time.zone.now) }

    it "is optional until the player submits it" do
      expect(game).to be_valid
    end

    it "strips surrounding whitespace" do
      game.player_name = "  Waldo  "

      expect(game.player_name).to eq("Waldo")
    end

    it "rejects a name made only of spaces" do
      game.player_name = "   "

      expect(game).not_to be_valid
    end

    it "rejects a name longer than 10 characters" do
      game.player_name = "a" * 11

      expect(game).not_to be_valid
    end

    it "accepts a name of 10 characters" do
      game.player_name = "a" * 10

      expect(game).to be_valid
    end
  end
end
