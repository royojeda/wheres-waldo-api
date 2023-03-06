class GamesController < ApplicationController
  def create
    game = Game.start(session[:characters])

    session[:timer_started] = true
    render json: game, only: [:id]
  end

  def update
    game = Game.find(params[:id])

    if game.completed? || updating_set_name?(game) || updating_set_time?(game) || !game.record(game_params)
      return head(:bad_request)
    end

    head :ok
  end

  private

  def game_params
    params
      .require(:game)
      .permit(:player_name, found_characters: %i[id name x_coordinate y_coordinate])
      .to_h
      .symbolize_keys
  end

  def updating_set_time?(game)
    game.end_time && game_params[:found_characters]
  end

  def updating_set_name?(game)
    game.player_name && game_params[:player_name]
  end
end
