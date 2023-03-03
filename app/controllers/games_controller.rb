class GamesController < ApplicationController
  def create
    game = Game.start(session[:characters])

    session[:timer_started] = true
    render json: game, only: [:id]
  end
end
