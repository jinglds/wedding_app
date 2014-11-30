WeddingApp::Application.routes.draw do

  root  'static_pages#home'
  namespace :api, defaults: {format: 'json'}  do
    resources :users
    get "my_shops", to: "users#shops"
    match "get_shop", to: "shops#get_shop", via: 'post'
    resources :favorite_shops, only: [:create, :destroy, :unfav]
    resources :favorites, only: [:destroy]
    resources :articles
    resources :shops  do 
      resources :photos
      resources :comments do
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
    get "tags", to: "shops#tags"
    resources :events do
      put "default_tasks", to: "events#create_default_tasks"
      put "clear_tasks", to: "events#clear_tasks"
      get "vendors", to: "events#vendors"
      resources :checklists do
        put "complete", to: "checklists#complete"
        put "decomplete", to: "checklists#decomplete"
      end
      resources :tasks do
        put "complete", to: "tasks#complete"
        put "decomplete", to: "tasks#decomplete"
      end
      resources :expenses do
        put "pay", to: "expenses#pay"
        put "unpay", to: "expenses#unpay"
      end
      resources :guests do
        put "attending", to: "guests#attending"
        put "invitation_sent", to: "guests#invitation_sent"
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
  resources :articles do
    put "publish", to: "articles#publish"
    put "unpublish", to: "articles#unpublish"
  end
  resources :vendors
  resources :event_vendors
  resources :events do
    match 'guests/manage_tables' => 'guests#manage_tables', :via => :get
    put "clear_tasks", to: "events#clear_tasks"
    post "default_tasks", to: "events#create_default_tasks"
    get "new_cont", to: "events#new_cont"
    resources :checklists do
      put "complete", to: "checklists#complete"
      put "decomplete", to: "checklists#decomplete"
    end
    resources :expenses do
      put "pay", to: "expenses#pay"
      put "unpay", to: "expenses#unpay"
    end

    resources :tasks do
      put "complete", to: "tasks#complete"
      
  # match "complete", to: "tasks#complete", via: 'get'
      put "decomplete", to: "tasks#decomplete"

      put "add_vendor", to: "tasks#add_vendor"
      put "remove_vendor", to: "tasks#remove_vendor"
      get "js_tasks", to: "tasks#js_tasks" 
    end
    resources :guests do
      put "attending", to: "guests#attending"
      put "invitation_sent", to: "guests#invitation_sent"
      put "set_table", to: "guests#set_table"
      put "clear_table", to: "guests#clear_table", :on => :collection
    end
  end
  resources :favorite_shops, only: [:create, :destroy]
  # resources :photos
  resources :shops do
      resources :photos
      get "new_gallery", to: "photos#new_gallery"
      get "edit_gallery", to: "photos#edit_gallery"
      put "set_cover", to: "photos#set_as_cover"
    resources :comments do
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

  match '/information',    to: 'static_pages#information',    via: 'get'
  match '/myshops', to: 'users#shops', via: 'get'
  match '/myevents', to: 'users#events', via: 'get'

  match '/pendings', to: 'users#pendings', via: 'get'
  match "category", to: "shops#category", via: 'get'
  match "my_tasks", to: "events#my_tasks", via: 'get'
  match "calendar", to: "tasks#calendar", via: 'get'
  get "/style_tags" => 'shops#style_tags', as: 'style_tags'
  match "user_category", to: "users#category", via: 'get'
  
  match 'guests/all' => 'guests#update_all', :as => :update_all, :via => :put
  
  
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
