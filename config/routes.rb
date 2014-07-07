Rebankme::Application.routes.draw do

  root 'static#home'

  get 'demo', to: 'demo#start', as: :demo_root
  get 'demo/v1', to: 'demo#show_page', defaults: { version: 'v1', page: 'start' }
  get 'demo/v2', to: 'demo#show_page', defaults: { version: 'v2', page: 'start' }
  get 'demo/:version/:page', to: 'demo#show_page', as: :demo

end
