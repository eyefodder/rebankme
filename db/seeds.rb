# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w{prepay_card second_chance safe_account special_group regular_account credit_union}.each do |name_id|
 AccountType.where(name_id: name_id).first_or_create!
end

%w{avi@significancelabs.org paul@significancelabs.org stephanie@significancelabs.org}.each do |email|
 AdminUser.where(email: email).first_or_create!(password: 'changeme', password_confirmation: 'changeme')
end


