class EventsController < ApplicationController
  def show
    @event = Event.includes(:period, :category, :region, :study_unit, characters: [ :period, :region ]).find(params[:id])
  end
end
