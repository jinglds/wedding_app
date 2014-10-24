WeddingApp::Application.routes.draw do
  
  devise_for :users
  resources :users
  resources :events
  resources :favorite_shops, only: [:create, :destroy]
  resources :shops do
   member do
      put "rate", to: "shops#rate"
      put "unrate", to: "shops#unrate"
    end
  end
  root  'static_pages#home'
  devise_scope :user do
    match "signin", to: "devise/sessions#new", via: 'get'
    match "signout", to: "devise/sessions#destroy", via: 'delete'
    match "signup", to: "devise/registrations#new", via: 'get'
    match "edit_account", to: "devise/registrations#edit", via: 'get'
    match "delete_user", to: "devise/registrations#destroy", via: 'delete'
  end
  match '/vendors',    to: 'static_pages#vendors',    via: 'get'
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
