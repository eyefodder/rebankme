# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
FactoryGirl.define do

  sequence :name, aliases: [:name_id, :code] do |n|
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
  factory :special_group do
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

  factory :state do
    code
    name
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
