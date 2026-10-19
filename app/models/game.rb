class Game < ApplicationRecord
  has_many :character_assignments, dependent: :destroy
  has_many :characters, through: :character_assignments

  normalizes :player_name, with: ->(name) { name.strip }
  validates :player_name, presence: true, length: { maximum: 10 }, allow_nil: true

  def self.high_scores
    where.not(end_time: nil).order(Arel.sql("end_time - start_time"), :id).limit(5)
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
