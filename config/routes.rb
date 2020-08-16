Rails.application.routes.draw do

  


  get 'admins/index'
  get 'profile_pictures/create'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :events


  #On fait des redirect parce que, pour le paiement et pour créer une participation, 
  # on a besoin de récupérer des infos des events (typiquemqent event.id)
  resources :events do
    resources :charges
  end

  resources :events do
    resources :attendances
  end

  resources :events do
    resources :event_pictures, only: [:create]
  end

  #On ne veut pas que ça en fasse trop pour se culbuter avec les trucs de Devise
  resources :users, only: [:show]

  resources :users do
    resources :profile_pictures, only: [:create]
  end

  resources :user_admins do
    resources :events, :users
  end

  resources :admins, only: [:index]

  root 'events#index'
end
