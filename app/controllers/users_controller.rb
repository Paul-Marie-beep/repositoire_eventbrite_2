class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
 
    #On fait ça pour ne pas permettre à une utilisateur lambda de voir un profil qui n'est pas le sien. (à moins qu'il ne soit administrateur)
    if current_user == @user || current_user.is_admin == true
      @user_events = Event.where(admin_id: @user.id)
    else
     redirect_to root_path
    end
  end

  


  
end
