Rails.application.routes.draw do
  resources :characters, only: [:index]
  resources :games, only: [:create]
end
