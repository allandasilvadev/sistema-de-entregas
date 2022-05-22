Rails.application.routes.draw do
  root to: 'home#index'
  resources :carriers, only: [:index, :show, :new, :create, :edit, :update]
  get '/carriers/:id/disable', to: 'carriers#disable', as: 'disable_carrier'
  post '/carriers/disable', to: 'carriers#disable_post', as: 'disable_carrier_post'

  resources :vehicles, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :prices, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :terms, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :orders, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  get '/orders_all/', to: 'orders#all', as: 'orders_all'
  get '/orders_one/:id', to: 'orders#getOne', as: 'order_get'
  get '/orders_accept/:id', to: 'orders#accept', as: 'order_accept'

  put '/orders_accept/:id', to: 'orders#accept_update'
  patch '/orders_accept/:id', to: 'orders#accept_update'
end
