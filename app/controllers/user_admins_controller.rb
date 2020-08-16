class UserAdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin

  def index
    @all_users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if  @user.update(user_params)
      redirect_to user_admins_path
      flash[:succes] = "Vous avez modifié le profil de cet utilisateur"
    else
      flash[:warning] = "Nous n'avons pas pu modifier votre événement"
      render 'edit.html.erb'
    end
  end
   



  def destroy
    #Grâce à nos routes imbriquées, on peut récupérer l'info de l'id du user dans le params
    @user = User.find(params[:id])
    @user.destroy
    redirect_to user_admins_path
    flash[:succes] = "Vous avez supprimé cet utilisateur"
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

  def user_params
    @user_params =  {email: params[:email], password: params[:password]}
  end
  
end
