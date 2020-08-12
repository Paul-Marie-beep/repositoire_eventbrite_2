class EventsController < ApplicationController
  def index
    @all_events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    end_date(@event)
  end

  def new 
    @new_event = Event.new #il faut créer l'élément pour que le formulaire fonctionne
  end

  def create
    @all_events = Event.all #Vu qu'on renvoie sur l'index si la création marche il faut initialiser @all_events

    @new_event = Event.new(start_date: params[:start_date], duration: params[:duration], title: params[:title], description: params[:description], price: params[:price], location: params[:location])
    @new_event.admin = current_user
      if @new_event.save
        render 'index.html.erb'
      else
        render 'new.html.erb'
      end
  end


  private

  def end_date(event)
    @end_date = event.start_date + event.duration
  return @end_date
  end  


end
