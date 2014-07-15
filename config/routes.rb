Rebankme::Application.routes.draw do

  devise_for :admin_users, skip: [:registrations]
  as :admin_user do
    get 'admin_users/edit' => 'devise/registrations#edit', :as => 'edit_admin_user_registration'
    put 'admin_users/:id' => 'devise/registrations#update', :as => 'admin_user_registration'
  end

  root 'static#home'

  get 'start', to: 'account_finder#start', as: :account_finder_start
  match 'account_finder', to: 'account_finder#next_type_question', as: :account_type_finder, via: [:get, :post]

  match 'find_account/:user_id/:account_type_id', to: 'account_finder#find_account', as: :account_finder, via: [:get, :post]

  get 'admin', to: 'admin#home', as: :admin

  scope '/admin' do
    resources :banks
    resources :branches
    resources :bank_accounts
  end

  get 'demo', to: 'demo#start', as: :demo_root
  get 'demo/v1', to: 'demo#show_page', defaults: { version: 'v1', page: 'start' }
  get 'demo/v2', to: 'demo#show_page', defaults: { version: 'v2', page: 'start' }
  get 'demo/:version/:page', to: 'demo#show_page', as: :demo

  # resources :account_types
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  # devise_scope :user do
  #   get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
  #   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end
end
