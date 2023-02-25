class CharactersController < ApplicationController
  def index
    @character = Character.locate(character_params)

    render json: @character, only: %i[name x_coordinate y_coordinate]
  end

  private

  def character_params
    params.require(:name)
    params.require(:x_coordinate)
    params.require(:y_coordinate)
    params.permit(:name, :x_coordinate, :y_coordinate).to_h.symbolize_keys
  end
end
