# rubocop:disable Metrics/MethodLength
class CharactersController < ApplicationController
  def index
    if request.query_string.present?
      if session[:timer_started]
        @character = Character.locate(character_params)

        render json: @character, only: %i[id name x_coordinate y_coordinate]
      else
        render json: { error: "The timer has not been started." }
      end
    else
      reset_session

      # Temporary. Set this on the future GamesController#create
      session[:timer_started] = true

      render json: Character.to_find, only: %i[id name]
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

# rubocop:enable Metrics/MethodLength
