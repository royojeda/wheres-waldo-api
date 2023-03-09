class Game < ApplicationRecord
  has_many :character_assignments, dependent: :destroy
  has_many :characters, through: :character_assignments

  def self.with_same_characters(found_characters)
    all.includes(:characters).order(:id).select do |game|
      game.end_time && game.characters.pluck(:id).sort == found_characters.pluck("id").sort
    end
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
    (if game_params[:player_name]
       update(player_name: game_params[:player_name].to_s)
     end) || (update(end_time: Time.zone.now) if found_characters?(game_params[:found_characters]))
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
