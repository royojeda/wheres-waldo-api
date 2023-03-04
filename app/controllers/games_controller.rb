class GamesController < ApplicationController
  def create
    game = Game.start(session[:characters])

    session[:timer_started] = true
    render json: game, only: [:id]
  end

  def update
    game = Game.find(params[:id])

    return head(:bad_request) unless game.finished?(game_params[:found_characters])

    game.stop_time
    head :ok
  end

  private

  def game_params
    params
      .require(:game)
      .permit(found_characters: %i[id name x_coordinate y_coordinate])
      .to_h
      .symbolize_keys
  end
end
