class EventSubmissionsController < ApplicationController


  def index
    @all_events_pending = Event.where(validated: nil)
  end
  
  def update

  end

end
