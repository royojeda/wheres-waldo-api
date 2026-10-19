require "rails_helper"

RSpec.describe "Games" do
  describe "GET /games" do
    let(:start_time) { Time.zone.parse("2026-01-01 12:00:00") }
    let(:batman) { Character.create!(name: "Batman", x_coordinate: 0.1, y_coordinate: 0.8) }
    let(:mario) { Character.create!(name: "Mario", x_coordinate: 0.07, y_coordinate: 0.25) }

    before do
      [30, 10, 50, 20, 40, 60].each_with_index do |seconds, i|
        Game.create!(player_name: "player#{i}", start_time:, end_time: start_time + seconds,
                     characters: [i.even? ? batman : mario])
      end
      Game.create!(player_name: "unfinished", start_time:)
    end

    it "returns the five fastest completed games regardless of their characters" do
      get games_path

      expect(response.parsed_body.pluck("score")).to eq([10.0, 20.0, 30.0, 40.0, 50.0])
    end

    it "includes only the id, player name and score of each game" do
      get games_path

      expect(response.parsed_body.first.keys).to contain_exactly("id", "player_name", "score")
    end
  end
end
