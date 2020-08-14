Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"

  resources :merchants
  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"

  resources :items, only: [:index, :show, :edit, :update, :destroy]
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  # delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]
  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/:item_id", to: "cart#update_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  resources :orders, except: [:index, :edit, :update]
  # get "/orders/new", to: "orders#new"
  # post "/orders", to: "orders#create"
  # get "/orders/:id", to: "orders#show"
  # delete "/orders/:id", to: "orders#destroy"
  patch "/orders/:order_id", to: 'orders#update'

  get "/register", to: 'users#new'
  post "/register", to: 'users#create'

  get "/login", to: 'sessions#new'
  post "/login", to: 'sessions#create'
  delete "/logout", to: 'sessions#destroy'

  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'
  get '/profile/password_edit', to: 'users#edit_password' #passwordscontroller?
  patch '/profile/password_update', to: 'users#update_password'
  get '/profile/orders', to: 'user_orders#index'
  get '/profile/orders/:order_id', to: 'user_orders#show'

  namespace :admin do
    get "/dashboard", to: 'dashboard#index'
    get "/merchants/:merchant_id", to: "merchants#show"
    patch '/dashboard', to: 'dashboard#update'
    get "/merchants", to: 'merchants#index'
    delete "/merchants/:merchant_id", to: 'merchants#destroy'
    patch "/merchants/:merchant_id", to: 'merchants#update'
    get "/merchants/:merchant_id/items", to: 'items#index'
    patch "/items/:item_id/toggle", to: 'toggle_items#update'
    delete "/items/:item_id", to: 'items#destroy'
    get "/merchants/:merchant_id/items/new", to: 'items#new'
    post "/merchants/:merchant_id/items", to: 'items#create'
    get "/merchants/:merchant_id/items/:item_id/edit", to: 'items#edit'
    patch "/merchants/:merchant_id/items/:item_id", to: 'items#update'
    get "/users", to: "users#index"
    get "/users/:user_id", to: "users#show"
    get "/orders/:order_id", to: 'orders#show'
  end

  namespace :merchant do
    get "/dashboard", to: 'dashboard#index'
    get "/items", to: "items#index"
    get "/orders/:order_id", to: "orders#show"
    delete "/items/:item_id", to: 'items#destroy'
    patch "/items/:item_id/toggle", to: 'toggle_items#update'
    get "/items/new", to: 'items#new'
    post "/items", to: 'items#create'
    get "/items/:item_id", to: "items#show"
    get "/items/:item_id/edit", to: 'items#edit'
    patch "/items/:item_id", to: 'items#update'
    patch "/items/:item_order_id/fulfill", to: "fulfill#update"
  end
end
