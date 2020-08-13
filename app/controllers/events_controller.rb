class EventsController < ApplicationController
  def index
    @all_events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    end_date(@event)
    @np= not__a_participant(@event)

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

  #Trouver la date de fin de l'événement
  def end_date(event)
    @end_date = event.start_date + event.duration
  return @end_date
  end  

  #Vérifier que quelqu'un qui est connecté sur le site ne participie pas déjà à l'événement dont il regarde la page
  def not__a_participant(event)
    if current_user  #Pour pas casser le site si on veut voir une page en étant pas connecté (dans l'idée, il faudrait pouvoir cliquer sur le bouton en étant pas connecté mais on verra après)
      #Attendance, c'est la table de jointure users/events —> On cherche les attendances qui font correspondre le personne connectée avec les événéments qu'il regarde
        att_list = Attendance.where(event_id: @event.id, user_id: current_user.id)
      #C'est un tableau: s'il est vide, alors c'est que le current_user ne participe pas à l'événement en question
      if att_list == []
        return true
      end
    end  
  end





end
