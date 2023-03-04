class Game < ApplicationRecord
  has_many :character_assignments, dependent: :destroy
  has_many :characters, through: :character_assignments

  def self.start(characters)
    game = create(start_time: Time.zone.now)
    game.assign_characters(characters)
    game
  end

  def assign_characters(characters)
    self.characters = Character.from_partials(characters)
  end

  def stop_time
    update(end_time: Time.zone.now)
  end

  def finished?(found_characters)
    start_time && !end_time && found_everyone?(found_characters)
  end

  def found_everyone?(found_characters)
    ((correct_answer - found_characters) + (found_characters - correct_answer)).empty?
  end

  def correct_answer
    characters.map do |char|
      char.slice(:id, :name, :x_coordinate, :y_coordinate)
    end
  end
end
