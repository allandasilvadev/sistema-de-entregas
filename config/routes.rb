Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  
  resources :carriers, only: [:index, :show, :new, :create, :edit, :update] do
    get 'disable', on: :member
    post 'disable_post', on: :collection
  end

  resources :vehicles, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :prices, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :terms, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :orders, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    get 'all', on: :collection
    get 'open', on: :collection
  end

  get '/orders_one/:id', to: 'orders#getOne', as: 'order_get'

  get '/orders_accept/:id', to: 'orders#accept', as: 'order_accept'
  put '/orders_accept/:id', to: 'orders#accept_update'
  patch '/orders_accept/:id', to: 'orders#accept_update'

  get '/orders_update_status/:id', to: 'orders#update_status', as: 'order_update_status'
  put   '/orders_update_status/:id', to: 'orders#upd_status'
  patch '/orders_update_status/:id', to: 'orders#upd_status'

  get 'prices_request', to: 'prices_request#index', as: 'prices_request'
  post 'prices_request', to: 'prices_request#create'
  get 'prices_request/all', to: 'prices_request#all', as: 'prices_request_all'
  
end
