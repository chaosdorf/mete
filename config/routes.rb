Mete::Application.routes.draw do

  # Redirections for legacy clients

  get 'audits.json', to: redirect('/api/v1/audits.json'), format: false

  get 'barcodes.json', to: redirect('/api/v1/barcodes.json'), format: false
  get 'barcodes/new.json', to: redirect('/api/v1/barcodes/new.json'), format: false
  get 'barcodes/:id.json', to: redirect('/api/v1/barcodes/%{id}.json'), format: false

  get 'drinks.json', to: redirect('/api/v1/drinks.json'), format: false
  get 'drinks/new.json', to: redirect('/api/v1/drinks/new.json'), format: false
  get 'drinks/:id.json', to: redirect('/api/v1/drinks/%{id}.json'), format: false

  get 'users.json', to: redirect('/api/v1/users.json'), format: false
  get 'users/new.json', to: redirect('/api/v1/users/new.json'), format: false
  get 'users/:id.json', to: redirect('/api/v1/users/%{id}.json'), format: false

  get 'users/:id/deposit.json', to: redirect('/api/v1/users/%{id}/deposit.json'), format: false
  get 'users/:id/payment.json', to: redirect('/api/v1/users/%{id}/payment.json'), format: false
  get 'users/:id/buy.json', to: redirect('/api/v1/users/%{id}/buy.json'), format: false
  get 'users/:id/buy_barcode.json', to: redirect('/api/v1/users/%{id}/buy_barcode.json'), format: false

  get 'users/stats.json', to: redirect('/api/v1/users/stats.json'), format: false

  # Regular routes

  resources :drinks
  resources :barcodes

  get 'audits' => 'audits#index'

  resources :users do
    member do
      get 'deposit'
      get 'payment'
      get 'buy'
      post 'buy_barcode'
      post 'print_label'
    end
    collection do
      get 'stats'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :audits
      resources :drinks
      resources :barcodes
      resources :users do
        member do
          get 'deposit'
          get 'payment'
          get 'buy'
          post 'buy_barcode'
        end
        collection do
          get 'stats'
        end
      end
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'users#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
