FactoryGirl.define do

  sequence :name, aliases: [:name_id] do |n|
    "Name#{n}"
  end
  sequence :email do |n|
    "#{n}test@test.com"
  end

  factory :user do
    zipcode '11205'
  end

  factory :account_type do
    name_id
  end


end
