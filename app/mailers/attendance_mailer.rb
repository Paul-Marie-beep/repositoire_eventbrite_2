class AttendanceMailer < ApplicationMailer
    default from: 'paulmarie.dev@gmail.com'
   
    def new_attendance(attendance)
      #on récupère l'instance user pour ensuite pouvoir la passer à la view en @user
      @attendance = attendance
      @admin = User.find(@attendance.event.admin_id)  

      #on définit une variable @url qu'on utilisera dans la view d’e-mail
      @url  = 'https://fierce-plateau-62518.herokuapp.com/login' 
  
      # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
      mail(to: @admin.email, subject: 'Nouvelle participation à votre événement !') 
    end
end
