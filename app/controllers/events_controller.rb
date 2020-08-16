class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :create]
  before_action :is_admin, only: [:edit, :update, :destroy]
  before_action :event_chosen, only: [:show, :edit, :update, :destroy]
  before_action :is_validated, only: [:edit]


  def index
    @all_events_validated = Event.where(validated: true)
  end

  def show
    #Il ne faut pas qu'un utilisateur lambda puisse accéder à la page d'un événement non-validé 
    #mais il faut qu'un admin le puisse (cf.la def de la méthode ci-dessous)
    is_validated_or_website_admin
    @not_participant= not__a_participant
    @not_admin = not_admin
    @current_user_is_admin = current_user_is_admin #(OSF) Pour régler les effets de bord de la condition pour qu'un admin puisse dévalider un truc déjà validé
  end 

  

  def new 
    @new_event = Event.new #il faut créer l'élément pour que le formulaire fonctionne
  end

  def create
    @all_events = Event.all #Vu qu'on renvoie sur l'index si la création marche il faut initialiser @all_events

    @new_event = Event.new(start_date: params[:start_date], duration: params[:duration], title: params[:title], description: params[:description], price: params[:price], location: params[:location])
    @new_event.admin = current_user
      if @new_event.save
        redirect_to events_path
      else
        render 'new.html.erb'
      end
  end


  def edit
  end

  def update
   if  @event.update(event_params)
    redirect_to event_path(@event.id)
    flash[:succes] = "Vous avez modifié votre événement"
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






  private #Aller voir les helpers pour vérifier si des choses n'y sont pas

  #Trouver la date de fin de l'événement
  def end_date
    @end_date = @event.start_date + @event.duration
  return @end_date
  end  

  #Vérifier que quelqu'un qui est connecté sur le site ne participie pas déjà à l'événement dont il regarde la page
  def not__a_participant
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

  def event_params
    @event_params = params.require(:event).permit(:title, :description, :start_date, :duration, :price, :location) 
  end

  def is_validated_or_website_admin
    #En gros, si l'événement est validé, tous les gens connectés peuvent le voir mais s'il n'est pas validé,
    # il faut être administrateur pour aller sur la page de l'événement.
    event_chosen
    if @event.validated == true
    else
      if current_user.is_admin == true
      else
        redirect_to root_path
        flash[:alert] = "Cet événement est en attente de validation"
      end
    end
  end

  def current_user_is_admin
    if current_user && current_user.is_admin == true
      return true
    else
      return false
    end
  end
  




end
