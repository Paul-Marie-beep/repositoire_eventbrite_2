class EventsController < ApplicationController
  def index
    @all_events = Event.all
  end
end
