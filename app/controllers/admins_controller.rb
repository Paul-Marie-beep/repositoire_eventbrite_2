class AdminsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :check_if_admin, only: [:index]

  
  
  
  
  
  def index
    
  end



  private

  def check_if_admin
    @user = current_user
    if @user.is_admin == true
    else
      redirect_to root_path
      flash[:warning] = "Vous devez être administrateur pour accéder à cette partie du site"
    end
  end  


end

