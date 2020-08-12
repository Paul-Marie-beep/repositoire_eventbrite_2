class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
 
    if current_user == @user
      @user_events = Event.where(admin_id: @user.id)
    else
     redirect_to root_path
    end
  end

end
