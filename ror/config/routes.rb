# -*- encoding : utf-8 -*-
Soya::Application.routes.draw do

  get "alert/sendmail"

  get "alert/sendsms"

  get "search/index"

  get "search/searchlist"

  get "dashboard/index"
  get "dashboard/report1"
  get "dashboard/report2"
  get "dashboard/report3"

  get "alert/index"

  get "alert/spider"

  get "hots/downloads"
  
  get "alert/alertlist"

  get "overview/index"

  get "overview/update_keywords"

  get "show/index"

  get "show/bysource"

  get "show/bylabel"
 
  get "show/byopponent"

  get "show/infoindex"

  get "hots/index"

  get "hots/new"

  get "system_setting/index"

  get "search/downloads"

  post "hots/create"

  get "system_setting/index"
  get "system_setting/overall_config"
  get "system_setting/label_config"
  get "system_setting/label_keywords_config"
  get "system_setting/info_source_type_config"

  post "system_setting/overall_create"
  post "system_setting/label_create"
  post "system_setting/label_keywords_create"
  post "system_setting/info_source_type_update"
  post "alert/update_task_status"  


  match "show/single_opponent/:id" , :to => "show#single_opponent"

  match "show/single/:info_type/:id", :to=> "show#single"

  match "inbox/single/:info_type/:id", :to=> "inbox#single"


  match "show/:info_type/index", :to => "show#infoindex"

  match "show/:info_type/:page", :to => "show#infolist"

  match "show/label/:label_id/index", :to => "show#infoindex_label"

  match "show/label/:label_id/:page", :to => "show#infolist_label"  

  match "show/bylabel/:label_id/:page", :to => "show#labelinfolist"
  

  match "show/bysource/:info_type/:page", :to => "show#sourceinfolist"


  match "show/opponent/:opponent_keyword_id/index", :to => "show#infoindex_opponent"

  match "show/opponent/:opponent_keyword_id/:page", :to => "show#infolist_opponent"  

  match "show/byopponent/:opponent_keyword_id/:page", :to => "show#opponentinfolist"


  match "inbox/:info_type/label/:label_id/index", :to => "inbox#infoindex_label"

  match "inbox/:info_type/label/:label_id/:page", :to => "inbox#infolist_label"



  match "inbox/monitor/:info_id", :to=>"inbox#monitor"
  
  match "inbox/:info_type/monitoring", :to=>"inbox#monitoring"

  match "inbox/unmonitor/:info_id", :to=>"inbox#unmonitor"
  
  match "inbox/:info_type/handlelist", :to => "inbox#handlelist"

  match "inbox/:info_type/index", :to => "inbox#infoindex"

  match "inbox/:info_type/:page", :to => "inbox#infolist"

  match "inbox/:info_type/:info_id/set_urgency/:urgency", :to=>"inbox#set_urgency"

  match "inbox/:info_type/:info_id/ignore", :to=>"inbox#ignore"

  match "inbox/:info_type/:info_id/unignore", :to=>"inbox#unignore"

  match "inbox/:info_type/:info_id/handle", :to=>"inbox#handle"


  match "alert/:info_type/ignore", :to=>"alert#ignore"

  match "alert/:info_type/unignore", :to=>"alert#unignore"

  match "alert/:info_type/handle", :to=>"alert#handle"

  match "overview/update_keywords", :to=>"overview#update_keywords"
 
  match "hots/destroy/:id", :to => "hots#destroy"

  match "hots/show/:id", :to => "hots#show"

  match "hots/resultlist/:id", :to => "hots#resultlist"
  
  match "hots/report/:id", :to => "hots#report"

  match "classify/:info_type/:info_id", :to => "classifier#classify"



  get "classifier/train_histroy"

  devise_for :admins

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


  devise_scope :admin do
    get 'login', :to => 'devise/sessions#new'
    get '/admins/sign_out' => 'devise/sessions#destroy'
  end

 
  root :to => "overview#index"


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
