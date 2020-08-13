class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
 
    #On fait ça pour ne pas permettre à une utilisateur lambda de voir un profil qui n'est pas le sien.
    if current_user == @user
      @user_events = Event.where(admin_id: @user.id)
    else
     redirect_to root_path
    end
  end

end
