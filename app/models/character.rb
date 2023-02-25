class Character < ApplicationRecord
  def self.locate(character_params)
    character_params => {name:, x_coordinate:, y_coordinate:}
    Rails.logger.debug "\n\n"
    Rails.logger.debug name
    Rails.logger.debug x_coordinate
    Rails.logger.debug y_coordinate
    Rails.logger.debug "\n\n"

    # Return all characters for now
    all
  end
end
