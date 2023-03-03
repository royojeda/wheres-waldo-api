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
end
