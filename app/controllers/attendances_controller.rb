class AttendancesController < ApplicationController
  before_action :authenticate_user!
  #Bien vérifier que ce genre de page est inaccessible aux utilisateurs qui ne sont pas connectés
  
  def new
    create
  end

  def create
    event_chosen
    #On pose une condition pour s'assurer qu'on ne puisse pas se retrouver là juste avec les URL.
    if current_user != @event.admin && not__a_participant(@event)
       Attendance.create(event: @event, user: current_user, stripe_customer_id: params[:stripeToken])
    else 
      redirect_to root_path
      flash[:alert] = "Tu fais nimp"   
    end
  end

  def index
    event_chosen
    @not_admin = not_admin(@event)
    #S'ils essaient de parvenir à la page index via URL, on les dégage
    if @not_admin 
      redirect_to root_path
      flash[:alert] = "Tu fais nimp" 
    end

    #On sélectionne uniquement les attendances qui concernent notre événement
    @all_attendances_for_this_event = Attendance.where(event_id: @event.id)


  end



  private

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
    @event = Event.find(params[:event_id])
  end

  def not_admin(event)
    if current_user != event.admin
      return true
    else 
      return false  
    end
  end

end
