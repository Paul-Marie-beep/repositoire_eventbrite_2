class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :create]
  before_action :is_admin, only: [:edit, :update, :destroy]
  before_action :event_chosen, only: [:show, :edit, :update, :destroy]


  def index
    @all_events = Event.all
  end

  def show
    end_date(@event)
    @not_participant= not__a_participant(@event)
    @not_admin = not_admin

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


  def edit
  end

  def update
    post_params
   if  @event.update(post_params)
    redirect_to event_path(@event.id)
    else
      flash[:warning] = "Nous n'avons pas pu modifier votre événement"
      render 'edit.html.erb'
    end
  end


  def destroy
    @event.destroy
    redirect_to root_path
    flash[:succes] = "Vous avez supprimé votre événement"
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

  def event_chosen
    @event = Event.find(params[:id])
  end

  def is_admin
    event_chosen
    if current_user == @event.admin
    else 
      redirect_to root_path
      flash[:alert] = "Vous n'êtes pas autorisé à faire cela"
    end
  end

  def not_admin
    event_chosen
    if current_user != @event.admin
      return true
    else 
      return false  
    end
  end

  def post_params
    @post_params = params.require(:event).permit(:title, :description, :start_date, :duration, :price, :location) 
  end



end
