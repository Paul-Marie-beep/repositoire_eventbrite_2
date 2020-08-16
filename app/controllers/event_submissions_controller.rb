class EventSubmissionsController < ApplicationController


  def index
    @all_events_pending = Event.where(validated: nil)
  end


  def edit #Je sais pas si on a vraiment le droit de faire ça parce que c'est un peu un détournement de méthodes mais à la limite ça évite de faire des conditions dans update
    @event = Event.find(params[:id])
    @event.validated = false
    @event.save
    redirect_to event_submissions_path
    flash[:success] = "Cet événement n'est pas validé"
  end
  
  def update
    @event = Event.find(params[:id])
    @event.validated = true
    @event.save
    redirect_to event_submissions_path
    flash[:success] = "Vous avez validé cet événement"
  end

end
