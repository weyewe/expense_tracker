Ticketie::Application.routes.draw do
  devise_for :users
  root :to => 'home#index'
  
  
  namespace :api do
    devise_for :users
    post 'authenticate_auth_token', :to => 'sessions#authenticate_auth_token', :as => :authenticate_auth_token 
    put 'update_password' , :to => "passwords#update" , :as => :update_password
    get 'search_role' => 'roles#search', :as => :search_role, :method => :get
    get 'search_user' => 'app_users#search', :as => :search_user, :method => :get
    get 'search_type' => 'types#search', :as => :search_type, :method => :get
    get 'search_item' => 'items#search', :as => :search_item, :method => :get
    
    # master data 
    resources :app_users
    resources :customers 
    resources :types  
    resources :items 
    resources :contract_maintenances 
    resources :contract_items 
    
    
  end
  
  
end
