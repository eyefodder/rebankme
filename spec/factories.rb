FactoryGirl.define do

  sequence :name, aliases: [:name_id] do |n|
    "Name#{n}"
  end
  sequence :email do |n|
    "#{n}test@test.com"
  end

  factory :user, aliases: [:nyc_user] do
    zipcode '11205'
    factory :non_nyc_user do
      zipcode '90210'
    end
  end

  factory :account_type do
    name_id
  end

  factory :bank do
    name
  end

  factory :admin_user do
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :address do
    zipcode '11205'
  end

  factory :branch do
    bank
    name
    zipcode '11205'
  end
  factory :bank_account do
    name
    account_type
    branch

  end


end
