require "rails_helper"

RSpec.describe "Games" do
  describe "GET /games" do
    let(:start_time) { Time.zone.parse("2026-01-01 12:00:00") }
    let(:batman) { Character.create!(name: "Batman", x_coordinate: 0.1, y_coordinate: 0.8) }
    let(:mario) { Character.create!(name: "Mario", x_coordinate: 0.07, y_coordinate: 0.25) }

    before do
      (1..12).reverse_each do |i|
        Game.create!(player_name: "player#{i}", start_time:, end_time: start_time + (i * 10),
                     characters: [i.even? ? batman : mario])
      end
      Game.create!(player_name: "unfinished", start_time:)
      Game.create!(start_time:, end_time: start_time + 5)
    end

    it "returns the ten fastest completed, named games regardless of their characters" do
      get games_path

      expect(response.parsed_body.pluck("score")).to eq((1..10).map { |i| i * 10.0 })
    end

    it "ranks the games from fastest to slowest" do
      get games_path

      expect(response.parsed_body.pluck("rank")).to eq((1..10).to_a)
    end

    it "includes only the id, player name, rank and score of each game" do
      get games_path

      expect(response.parsed_body.first.keys).to contain_exactly("id", "player_name", "rank", "score")
    end

    context "when the player's finished game ranks outside the top ten" do
      before do
        get characters_path
        post games_path
        Game.last.update!(player_name: "slowpoke", start_time:, end_time: start_time + 500)
        get games_path
      end

      it "appends the player's game with its rank" do
        expect(response.parsed_body.last).to include("player_name" => "slowpoke", "rank" => 13)
      end

      it "still returns the top ten before it" do
        expect(response.parsed_body.pluck("rank")).to eq((1..10).to_a + [13])
      end
    end

    context "when the player's finished game ranks inside the top ten" do
      before do
        get characters_path
        post games_path
        Game.last.update!(player_name: "speedy", start_time:, end_time: start_time + 15)
        get games_path
      end

      it "lists the player's game once, at its rank" do
        expect(response.parsed_body.pluck("player_name").first(3)).to eq(%w[player1 speedy player2])
      end

      it "returns only the top ten" do
        expect(response.parsed_body.length).to eq(10)
      end
    end

    context "when the games are archived" do
      before { Game.archive_all }

      it "returns no games" do
        get games_path

        expect(response.parsed_body).to be_empty
      end

      it "ranks new games from first place" do
        Game.create!(player_name: "newcomer", start_time:, end_time: start_time + 500)
        get games_path

        expect(response.parsed_body).to contain_exactly(include("player_name" => "newcomer", "rank" => 1))
      end

      it "returns them once restored" do
        Game.restore
        get games_path

        expect(response.parsed_body.pluck("score")).to eq((1..10).map { |i| i * 10.0 })
      end
    end

    context "when restoring an earlier batch" do
      before do
        first_batch = Game.archive_all
        Game.create!(player_name: "eventgoer", start_time:, end_time: start_time + 1)
        Game.archive_all
        Game.restore(first_batch)
        get games_path
      end

      it "returns that batch without the later one" do
        expect(response.parsed_body.pluck("player_name")).not_to include("eventgoer")
      end
    end
  end

  describe "PATCH /games/:id" do
    let(:game) { Game.create!(start_time: 1.minute.ago, end_time: Time.zone.now) }

    it "saves the player name" do
      patch game_path(game), params: { game: { player_name: "Waldo" } }, as: :json

      expect(game.reload.player_name).to eq("Waldo")
    end

    it "rejects a blank player name" do
      patch game_path(game), params: { game: { player_name: "   " } }, as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end
end
