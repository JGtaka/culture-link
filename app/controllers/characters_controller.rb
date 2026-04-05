class CharactersController < ApplicationController
  def show
    @character = Character.includes(:period, :region, :study_unit, events: [ :category, :period, :region ]).find(params[:id])
  end
end
