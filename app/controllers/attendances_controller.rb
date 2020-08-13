class AttendancesController < ApplicationController
  before_action :authenticate_user!
  #Bien vérifier que ce genre de page est inaccessible aux utilisateurs qui ne sont pas connectés
  
  def new
    create
  end

  def create
    @event = Event.find(params[:event_id])
    #On pose une condition pour s'assurer qu'on ne puisse pas se retrouver là juste avec les URL.
    if current_user != @event.admin && not__a_participant(@event)
       Attendance.create(event: @event, user: current_user, stripe_customer_id: params[:stripeToken])
    else 
      redirect_to root_path
      flash[:alert] = "Tu fais nimp"   
    end
  end

  def index
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

end
