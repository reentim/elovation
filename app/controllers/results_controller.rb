class ResultsController < ApplicationController
  before_filter :_find_game

  def show
    @result = Result.find(params[:id])
  end

  def create
    response = ResultService.create(@game, params[:result])

    if response.success?
      redirect_to game_path(@game)
    else
      @result = response.result
      render :new
    end
  end

  def destroy
    result = @game.results.find_by_id(params[:id])

    response = ResultService.destroy(result)

    redirect_to :back
  end

  def new
    @result = Result.new
    (@game.max_number_of_teams || 20).times{|i| @result.teams.build rank: i}
  end

  def _find_game
    @game = Game.find(params[:game_id])
  end
end
