Rebankme::Application.routes.draw do

  devise_for :admin_users, skip: [:registrations]
  as :admin_user do
    get 'admin_users/edit' => 'devise/registrations#edit', :as => 'edit_admin_user_registration'
    put 'admin_users/:id' => 'devise/registrations#update', :as => 'admin_user_registration'
  end

  root 'static#home'

  get 'start', to: 'account_finder#start', as: :account_finder_start
  match 'account_finder', to: 'account_finder#next_type_question', as: :account_type_finder, via: [:get, :post]

  match 'users/:user_id/find_account', to: 'account_finder#find_account', as: :account_finder, via: [:get, :post]

  resources :users
  get 'users/:user_id/request_email', to: 'users#request_email', as: :request_user_email
  get 'users/:user_id/:account_type_id/help_me_open', to: 'users#help_me_open', as: :account_opening_assistance


  get 'admin', to: 'admin#home', as: :admin

  scope '/admin' do
    resources :banks, :branches, :bank_accounts, only: [:index, :new, :create, :edit, :update, :destroy]

    authenticated :admin_user do
      match "/job_queue" => DelayedJobWeb, :anchor => false, via: [:get, :post], as: :job_queue
      match '/vanity(/:action(/:id(.:format)))', :controller => :vanity, :via => [:get, :post], as: :vanity
    end
  end






end
