class ChargesController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
    @amount = @event.price
    @amount_cent = @event.price*100

  end
  
  def create
    # Stripe fait sa vie. Bien adapter les paramètres amount pour être sûr d'avoir ce qu'on veut. 
    @event = Event.find(params[:event_id])
    @amount_cent = @event.price*100
  
    customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
    })
  
    charge = Stripe::Charge.create({
      customer: customer.id,
      amount: @amount_cent,
      description: 'Rails Stripe customer',
      currency: 'eur',
    })

    flash[:success] = "Vous avez validé votre participation à cet événement"
    redirect_to event_path(@event.id) #On redirect vers le controller pour créer une nouvelle attendance plutôt je pense. Après manger en tout cas.
    

  
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_event_charge_path(@event.id)
  end



end
