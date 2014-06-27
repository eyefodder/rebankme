Rebankme::Application.routes.draw do

  root 'static#home'

  get 'path/bank', to: 'account_selections#intro', as: :find_account_intro
  get 'path/bank/features/:id', to: 'account_selections#feature', as: :select_account_feature
end
