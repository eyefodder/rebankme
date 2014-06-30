Rebankme::Application.routes.draw do

  root 'static#home'

  get 'demo/:version/:page', to: 'demo#show_page', as: :demo

end
