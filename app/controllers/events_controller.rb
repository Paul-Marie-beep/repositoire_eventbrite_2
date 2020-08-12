class EventsController < ApplicationController
  def index
    @all_events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new 
    @new_event = Event.new
  end

  def create
    @new_event = Event.new(start_date: params[:start_date], duration: params[:duration], title: params[:title], description: params[:description], price: params[:price], location: params[:location])
    @new_event.admin = current_user
    @new_event.save
  end


end
