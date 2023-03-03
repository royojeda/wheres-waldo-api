# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
class Character < ApplicationRecord
  has_many :character_assignments, dependent: :destroy
  has_many :games, through: :character_assignments

  def self.locate(character_params)
    character_params => {name:, x_coordinate:, y_coordinate:}

    scale_factor = 30
    image_size = (2000.0 / 13111)

    width = (1.0 / scale_factor)
    height = (image_size * width)

    left_edge = x_coordinate.to_f - (0.5 * width)
    right_edge = x_coordinate.to_f + (0.5 * width)
    top_edge = y_coordinate.to_f - (0.5 * height)
    bottom_edge = y_coordinate.to_f + (0.5 * height)

    where(
      name:,
      x_coordinate: left_edge..right_edge,
      y_coordinate: top_edge..bottom_edge
    )
  end

  def self.to_find
    where(id: pluck(:id).sample(4))
  end

  def self.from_partial(character)
    find_by(id: character["id"], name: character["name"])
  end

  def self.from_partials(characters)
    characters.map do |character|
      from_partial(character)
    end
  end
end

# rubocop:enable Metrics/AbcSize, Metrics/MethodLength
