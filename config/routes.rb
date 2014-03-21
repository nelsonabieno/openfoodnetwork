Openfoodnetwork::Application.routes.draw do
  root :to => 'home#temp_landing_page'

  resource :shop, controller: "shop/shop" do
    get :products
    post :order_cycle
    get :order_cycle
  end

  namespace :shop do
    #resource :checkout, only: :edit, controller: :checkout do
      #get '', to: ""
    #end
    get '/checkout', :to => 'checkout#edit' , :as => :checkout
    put '/checkout', :to => 'checkout#update' , :as => :update_checkout

    get "/checkout/paypal_payment", to: 'checkout#paypal_payment', as: :paypal_payment
  end

  resources :enterprises do
    collection do
      get :suppliers
      get :distributors
      post :search
    end

    member do
      get :shop_front # new world
      get :shop # old world
    end
  end

  resources :suburbs

  namespace :admin do
    resources :order_cycles do
      post :bulk_update, :on => :collection, :as => :bulk_update
      get :clone, on: :member
    end

    resources :enterprises do
      post :bulk_update, :on => :collection, :as => :bulk_update
    end

    resources :enterprise_fees do
      post :bulk_update, :on => :collection, :as => :bulk_update
    end

    resources :enterprise_groups do
      get :move_up
      get :move_down
    end
  end

  namespace :api do
    resources :order_cycles do
      get :managed, on: :collection
    end
  end

  get "new_landing_page", :controller => 'home', :action => "new_landing_page"
  get "darkswarm", controller: :darkswarm, action: :index
  get "about_us", :controller => 'home', :action => "about_us"

  namespace :open_food_network do
    resources :cart do
      post :add_variant
    end
  end

  # Mount Spree's routes
  mount Spree::Core::Engine, :at => '/'
end


Spree::Core::Engine.routes.prepend do
  match '/admin/reports/orders_and_distributors' => 'admin/reports#orders_and_distributors', :as => "orders_and_distributors_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/group_buys' => 'admin/reports#group_buys', :as => "group_buys_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/bulk_coop' => 'admin/reports#bulk_coop', :as => "bulk_coop_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/payments' => 'admin/reports#payments', :as => "payments_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/orders_and_fulfillment' => 'admin/reports#orders_and_fulfillment', :as => "orders_and_fulfillment_admin_reports",  :via  => [:get, :post]
  match '/admin/products/bulk_edit' => 'admin/products#bulk_edit', :as => "bulk_edit_admin_products"
  match '/admin/orders/bulk_management' => 'admin/orders#bulk_management', :as => "admin_bulk_order_management"
  match '/admin/reports/products_and_inventory' => 'admin/reports#products_and_inventory', :as => "products_and_inventory_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/customers' => 'admin/reports#customers', :as => "customers_admin_reports",  :via  => [:get, :post]


  namespace :api, :defaults => { :format => 'json' } do
    resources :users do
      get :authorise_api, on: :collection
    end

    resources :products do
      get :managed, on: :collection
    end

    resources :enterprises do
      get :managed, on: :collection
    end
  end

  namespace :admin do
    resources :products do
      get :product_distributions, on: :member

      post :bulk_update, :on => :collection, :as => :bulk_update
    end
  end

  resources :orders do
    get :select_distributor, :on => :member
    get :deselect_distributor, :on => :collection
    get :clear, :on => :collection
    get :order_cycle_expired, :on => :collection
  end
end
