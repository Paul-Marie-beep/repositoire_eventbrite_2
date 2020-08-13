Rails.application.routes.draw do

  
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :events

  resources :events do
    resources :charges
  end

  #On ne veut pas que ça en fasse trop pour se culbuter avec les trucs de Devise
  resources :users, only: [:show]
  resources :attendances, only: [:new, :index]

  root 'events#index'
end
