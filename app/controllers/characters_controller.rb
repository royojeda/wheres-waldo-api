class CharactersController < ApplicationController
  def index
    if request.query_string.present?
      @character = Character.locate(character_params)

      render json: @character, only: %i[name x_coordinate y_coordinate]
    else
      render json: Character.all, only: :name
    end
  end

  private

  def character_params
    params.require(:name)
    params.require(:x_coordinate)
    params.require(:y_coordinate)
    params.permit(:name, :x_coordinate, :y_coordinate).to_h.symbolize_keys
  end
end
