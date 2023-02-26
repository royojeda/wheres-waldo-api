# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
class Character < ApplicationRecord
  def self.locate(character_params)
    character_params => {name:, x_coordinate:, y_coordinate:}

    left_edge = (x_coordinate.to_f - (1.0 / 60))
    right_edge = x_coordinate.to_f + (1.0 / 60)
    top_edge = y_coordinate.to_f - (100.0 / 39333)
    bottom_edge = y_coordinate.to_f + (100.0 / 39333)

    Rails.logger.debug
    Rails.logger.debug 1.0 / 60
    Rails.logger.debug 100.0 / 39333
    Rails.logger.debug

    where(
      name:,
      x_coordinate: left_edge..right_edge,
      y_coordinate: top_edge..bottom_edge
    )
  end
end

# rubocop:enable Metrics/AbcSize, Metrics/MethodLength
