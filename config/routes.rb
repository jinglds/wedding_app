WeddingApp::Application.routes.draw do

  root  'static_pages#home'
  namespace :api, defaults: {format: 'json'}  do
    match "get_shop", to: "shops#get_shop", via: 'post'
    resources :favorite_shops, only: [:create, :destroy, :unfav]
    resources :favorites, only: [:destroy]
    resources :shops  do   
      member do
        put "rate", to: "shops#rate"
        put "unrate", to: "shops#unrate"
      end
    end
    resources :events do
      resources :expenses do
        put "pay", to: "expenses#pay"
        put "unpay", to: "expenses#unpay"
      end
    end
     devise_for :users , :controllers => { :registrations => "api/registrations", :sessions => "api/sessions" }
    
  end


  get 'tags/:tag', to: 'shops#index', as: :tag


  devise_for :users #, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  resources :users do
    member do
      put "approve"
      put "set_admin"
    end
  end
  resources :vendors
  resources :event_vendors
  resources :events do
    post "default_tasks", to: "events#create_default_tasks"
    get "new_cont", to: "events#new_cont"
    
    resources :expenses do
      put "pay", to: "expenses#pay"
      put "unpay", to: "expenses#unpay"
    end

    resources :tasks do
      put "complete", to: "tasks#complete"
      
  # match "complete", to: "tasks#complete", via: 'get'
      put "decomplete", to: "tasks#decomplete"

      get "add_vendor", to: "tasks#add_vendor"
      put "remove_vendor", to: "tasks#remove_vendor"
      get "js_tasks", to: "tasks#js_tasks" 
    end
  end
  resources :favorite_shops, only: [:create, :destroy]
  # resources :photos
  resources :shops do
      resources :photos
      get "new_gallery", to: "photos#new_gallery"
      get "edit_gallery", to: "photos#edit_gallery"
      put "set_cover", to: "photos#set_as_cover"
    resources :comments, only: [:create, :destroy] do
      member do
        put "like", to: "comments#like"
        put "unlike", to: "comments#unlike"
      end
    end
    member do
      put "rate", to: "shops#rate"
      put "unrate", to: "shops#unrate"
    end
  end
  

  devise_scope :user do
    match "signin", to: "devise/sessions#new", via: 'get'
    match "signout", to: "devise/sessions#destroy", via: 'delete'
    match "signup", to: "devise/registrations#new", via: 'get'
    match "edit_account", to: "devise/registrations#edit", via: 'get'
    match "delete_user", to: "devise/registrations#destroy", via: 'delete'
  end
  match '/vendors',    to: 'static_pages#vendors',    via: 'get'
  match '/myshops', to: 'users#shops', via: 'get'
  match '/myevents', to: 'users#events', via: 'get'

  match '/pendings', to: 'users#pendings', via: 'get'
  match "category", to: "shops#category", via: 'get'
  match "my_tasks", to: "events#my_tasks", via: 'get'
  match "calendar", to: "tasks#calendar", via: 'get'
  get "/style_tags" => 'shops#style_tags', as: 'style_tags'
  match "user_category", to: "users#category", via: 'get'
  
  
# The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
