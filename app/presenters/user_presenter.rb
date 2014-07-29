class UserPresenter < BasePresenter
  presents :user
  text_field_tags_for [:email]

end