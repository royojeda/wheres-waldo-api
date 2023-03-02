class Game < ApplicationRecord
  has_many :character_assignments, dependent: :destroy
  has_many :characters, through: :character_assignments
end
