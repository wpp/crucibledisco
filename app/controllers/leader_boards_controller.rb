class LeaderBoard
  attr_accessor :users, :name, :ratings, :params

  MODE_MAP = {
    9  => 'skirmish',
    10 => 'control',
    11 => 'salvage',
    12 => 'clash',
    13 => 'rumble',
    14 => 'trials',
    15 => 'doubles',
    19 => 'iron banner',
    23 => 'elimination',
    24 => 'rift'
  }

  def initialize(params, sort_column, sort_direction)
    @params = params
    mode = params[:id] ? params[:id] : 14
    @name = MODE_MAP[mode.to_i]
    @ratings = Rating.where(mode: mode)
      .order(sort_column + " " + sort_direction)
      .includes(:user)
  end
end

class LeaderBoardsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    @leader_board = LeaderBoard.new(params, sort_column, sort_direction)
  end

  private
    def sort_column
      Rating.column_names.include?(params[:sort]) ? params[:sort] : 'elo'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end
end
