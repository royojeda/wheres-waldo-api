class Game < ApplicationRecord
  has_many :character_assignments, dependent: :destroy
  has_many :characters, through: :character_assignments

  normalizes :player_name, with: ->(name) { name.strip }
  validates :player_name, presence: true, length: { maximum: 10 }, allow_nil: true

  LEADERBOARD_SIZE = 10

  # The fastest completed, named games, plus the given game wherever it ranks.
  def self.leaderboard(including: nil)
    completed = where.not(end_time: nil).where.not(player_name: nil)
    ranked = completed.select("games.*, ROW_NUMBER() OVER (ORDER BY end_time - start_time, id) AS rank")

    from(ranked, :games).where("rank <= :size OR id = :id", size: LEADERBOARD_SIZE, id: including).order(:rank)
  end

  def self.start(characters)
    game = create(start_time: Time.zone.now)
    game.assign_characters(characters)
    game
  end

  def assign_characters(characters)
    self.characters = Character.from_partials(characters)
  end

  def record(game_params)
    if game_params[:player_name]
      update(player_name: game_params[:player_name].to_s)
    elsif found_characters?(game_params[:found_characters])
      update(end_time: Time.zone.now)
    end
  end

  def completed?
    player_name && end_time
  end

  def found_characters?(found_characters)
    ((correct_answer - found_characters) + (found_characters - correct_answer)).empty?
  end

  def correct_answer
    characters.map do |char|
      char.slice(:id, :name, :x_coordinate, :y_coordinate)
    end
  end

  def score
    end_time - start_time
  end
end
