Rails.application.routes.draw do

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }

  resources :users do
    get 'select2_index', on: :collection
    get 'datatables_index', on: :collection
    get 'datatables_index_role', on: :collection # Displays users for showed role
    patch 'account_off', on: :member
    patch 'account_on', on: :member
    patch 'set_activity_at', on: :member
    resources :attachments, module: :users, only: [:create] do
      post 'create_folder', on: :collection
    end
  end
  
  resources :customers do
    get 'select2_index', on: :collection
    get 'datatables_index', on: :collection
    resources :attachments, module: :customers, only: [:create] do
      post 'create_folder', on: :collection
    end
  end

  resources :projects do
    get 'show_charts', on: :collection
    get 'send_status', on: :member 
    get 'select2_index', on: :collection
    get 'datatables_index', on: :collection
    get 'datatables_index_customer', on: :collection # Displays projects for showed customer
    resources :attachments, module: :projects, only: [:create] do
      post 'create_folder', on: :collection
    end
    resources :point_files, module: :projects, except: [:index] do
      get 'download', on: :member
      get 'datatables_index_zs_point', on: :collection # Displays zs_points for showed point_file
      get 'datatables_index_ww_point', on: :collection # Displays ww_points for showed point_file
    end
    resources :proposal_files, module: :projects, except: [:index] do
      get 'download', on: :member
    end
  end

  resources :enrollments do
    resources :attachments, module: :enrollments, only: [:create] do
      post 'create_folder', on: :collection
    end
  end

  resources :roles do
    get 'datatables_index', on: :collection
    get 'datatables_index_user', on: :collection # Displays roles for showed user
    resources :users, only: [:create, :destroy], controller: 'roles/users'
  end    

  resources :accessorizations do
    get 'datatables_index_user', on: :collection # Displays accessorizations for showed user
    get 'datatables_index_role', on: :collection # Displays accessorizations for showed role
    get 'datatables_index_errand', on: :collection # Displays accessorizations for showed role
  end    

  resources :events do
    get 'show_charts', on: :collection
    get 'send_status', on: :member 
    post 'datatables_index', on: :collection
    resources :attachments, module: :events, only: [:create] do
      post 'create_folder', on: :collection
    end
    resources :photos, module: :events, only: [:create]
  end

  resources :errands do
    get 'show_charts', on: :collection
    get 'select2_index', on: :collection
    get 'datatables_index', on: :collection
    resources :attachments, module: :errands, only: [:create] do
      post 'create_folder', on: :collection
    end
  end

  resources :charts, only: [] do
    get 'errands_by_month', on: :collection
    get 'errands_by_status', on: :collection
    get 'events_by_status_for_errand', on: :collection
    get 'events_by_status_for_user', on: :collection
    get 'events_by_status_type_for_user', on: :collection
    get 'events_by_type_status_for_user', on: :collection
    get 'events_by_month', on: :collection
    get 'events_by_month_status', on: :collection
    get 'events_by_status', on: :collection
    get 'events_by_type', on: :collection
    get 'events_by_type_for_status', on: :collection
    get 'events_by_month_type', on: :collection
    get 'point_files', on: :collection
    get 'xml_miejsce_realizacji_tables', on: :collection
  end

  resources :works, only: [:index] do
    post 'datatables_index', on: :collection # for User
    post 'datatables_index_trackable', on: :collection # for Trackable
    post 'datatables_index_user', on: :collection # for User
  end

  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/help'

  resources :attachments, only: [:show, :edit, :update, :destroy] do
    get 'datatables_index', on: :collection # for Trackable
    get 'datatables_index_through_events', on: :collection # for Trackable
    get 'download', on: :member
    post 'move_to_photo', on: :member
  end

  resources :photos, only: [:show, :edit, :update, :destroy] do
    get 'datatables_index', on: :collection # for Trackable
    get 'datatables_index_through_events', on: :collection # for Trackable
    get 'download', on: :member
  end

  resources :zs_points
  resources :ww_points


end
