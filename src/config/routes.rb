CodeSwap::Application.routes.draw do
  get "admin/index"

  resources :file_submissions
  resources :authentications
  resources :user
  devise_for :users, :controllers => { :registrations => 'registrations'}

  get "home/index"

  match 'contact_us', :controller => 'home', :action => 'contact_us', :as => 'contact_us'
  match 'send_contact_email', :controller => 'home', :action => 'send_contact_email', :as => 'send_contact_email'

  root :to => "home#index"

  match '/auth/:provider/callback' => 'authentications#create'

  match '/users/sign_up' => 'home#index'

  match "admin/create_faculty", :controller => 'admin', :action => 'create_faculty'
  match 'admin', :controller => 'admin', :action => 'index', :as => 'admin_path'
  match 'users', :controller => 'admin', :action => 'index', :as => 'view_users'
  match 'admin/add_user', :controller => 'admin', :action => 'add_user'
  match 'view_faculty', :controller => 'admin', :action => 'view_faculty', :as => 'view_faculty'
  match 'view_admin', :controller => 'admin', :action => 'view_admin', :as => 'view_admin'
  match 'view_students', :controller => 'admin', :action => 'view_students', :as => 'view_students'
  match 'admin/delete_user', :controller => 'admin', :action => 'delete_user'
  match 'admin/search_users', :controller => 'admin', :action => 'search_users', :as => 'search_users'
  match 'admin/view_user_info', :controller => 'admin', :action => 'view_user_info', :as => 'view_user_info'
  match 'admin/recent_activity', :controller => 'admin', :action => 'view_recent_activity'

  # Faculty // Course Routes

  match 'course/show/:c_id', :controller => 'course', :action=>'show', :as => 'show_course'
  match 'course/edit/:id', :controller => 'course', :action => 'edit', :as => 'edit_course'
  match 'course/submit_edit', :controller => 'course', :action => 'submit_edit'
  match 'course/manage_groups/:id', :controller => 'course', :action => 'manage_groups'
  get "faculty/index"
  match 'faculty/index', :controller => 'faculty', :action => 'index', :as => 'faculty_index'
  match '/courses', :controller => 'faculty', :action => 'index', :as => 'course_index'
  match 'course/new', :controller => 'course', :action => 'new', :as => 'new_course'
  match 'course/create', :controller => 'course', :action => 'create', :as => 'create_course'
  match 'course/add_student', :controller => 'course', :action => 'add_student'
  
  # Assignment Routes
  get "assignment/index"
  match 'assignment', :controller => 'assignment', :action=> 'index'
  match 'assignments', :controller => 'assignment', :action=> 'index'
  match 'assignment/create/:course_id', :controller => 'assignment', :action => 'create' 
  match 'assignment/edit/:assignment_id', :controller => 'assignment', :action => 'edit' 
	match 'assignment/view/:assignment_id',:controller => 'assignment', :action => 'view', :as => 'assignment_view'
  match 'assignment/submit_new', :controller => 'assignment', :action => 'submit_new'
  match 'assignment/submitchanges', :controller =>'assignment', :action => 'submitchanges'
  match 'assignment/upload', :controller => 'assignment', :action => 'upload'
  match 'assignment/adminView/:assignment_id', :controller => 'assignment', :action => 'adminView'
  match 'assignment/download/:file_id', :controller => 'assignment', :action => 'download'
  match 'assignment/downloadAll/:assignment_id', :controller => 'assignment', :action => 'downloadAll'

  # Review Assignment Routes
  match 'reviewassignment/create/:assignment_id',:controller => 'review_assignment', :action => 'create'
  match 'reviewassignment/pairings',:controller => 'review_assignment', :action => 'pairings'
  match 'reviewassignment/pairings/:redo',:controller => 'review_assignment', :action => 'pairings'
  match 'reviewassignment/view/:id',:controller => 'review_assignment', :action => 'view'
  match 'reviewassignment/studentsubmit',:controller => 'review_assignment', :action => 'student_submit'
  match 'reviewassignment/viewsubmission/:mapping_id',:controller => 'review_assignment', :action => 'view_submission'
	match 'reviewassignment/:id/grades',:controller => 'review_assignment', :action => 'grades'
	match 'reviewassignment/:id/:pos/answer_form',:controller => 'review_assignment', :action => 'answer_form'
  match 'reviewassignment/edit/:id', :controller => 'review_assignment', :action => 'edit'
  match 'reviewassignment/view_feedback/:id' => 'review_assignment#view_feedback'
  match 'reviewassignment/submit_faculty_review/' => 'review_assignment#submit_faculty_review'
  
  # File Routes
  match 'files/delete/:file_id', :controller => 'file_submissions', :action => 'delete', :as => 'remove_file'
  match 'view_live/:file_id', :controller => 'file_submissions', :action => 'view_live', :as => 'view_live'


  #Redirect to 404 Page
  #This MUST be the last route
  match '*a', :to => 'errors#routing'
end
