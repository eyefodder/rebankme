Rebankme::Application.routes.draw do

  root 'static#home'

  get 'start', to: 'account_finder#start', as: :account_finder_start
  match 'account_finder', to: 'account_finder#next_type_question', as: :account_finder, via: [:get, :post]

  get 'demo', to: 'demo#start', as: :demo_root
  get 'demo/v1', to: 'demo#show_page', defaults: { version: 'v1', page: 'start' }
  get 'demo/v2', to: 'demo#show_page', defaults: { version: 'v2', page: 'start' }
  get 'demo/:version/:page', to: 'demo#show_page', as: :demo

end
