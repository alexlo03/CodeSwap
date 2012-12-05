CodeSwap::Application.routes.draw do
  get "admin/index"

  resources :file_submissions
  resources :authentications
  resources :user
  devise_for :users

  get "home/index"

  root :to => "home#index"

  match '/auth/:provider/callback' => 'authentications#create'

  match '/users/sign_up' => 'home#index'

  match "admin/create_faculty", :controller => 'admin', :action => 'create_faculty'
  match 'admin', :controller => 'admin', :action => 'index', :as => 'admin_path'
  match 'admin/add_user', :controller => 'admin', :action => 'add_user'
  match 'admin/view_faculty', :controller => 'admin', :action => 'view_faculty', :as => 'view_faculty'
  match 'admin/view_admin', :controller => 'admin', :action => 'view_admin', :as => 'view_admin'
  match 'admin/view_students', :controller => 'admin', :action => 'view_students', :as => 'view_students'
  match 'admin/view_tas', :controller => 'admin', :action => 'view_tas', :as => 'view_tas'
  match 'admin/delete_user', :controller => 'admin', :action => 'delete_user'
  match 'admin/search_users', :controller => 'admin', :action => 'search_users', :as => 'search_users'
  match 'admin/view_user_info', :controller => 'admin', :action => 'view_user_info', :as => 'view_user_info'
  match 'faculty/add_course', :controller => 'faculty', :action => 'add_course', :as => 'add_course'
  match 'course/show/:id', :controller => 'course', :action=>'show', :as => 'show_course'
  get "faculty/index"
  get "faculty/new_course" 
  get "faculty/add_course" 
  get "assignment/index"
  match 'assignment', :controller => 'assignment', :action=> 'index'
  match 'assignments', :controller => 'assignment', :action=> 'index'
  match 'assignment/create/:course_id', :controller => 'assignment', :action => 'create' 
	match 'assignment/view/:id',:controller => 'assignment', :action => 'view'
  match 'assignment/submit_new', :controller => 'assignment', :action => 'submit_new'
  match 'assignment/upload', :controller => 'assignment', :action => 'upload'


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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end