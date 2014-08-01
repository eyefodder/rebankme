# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#account types
%w{prepay_card second_chance safe_account special_group regular_account credit_union student_account seniors_account veterans_account}.each do |name_id|
 AccountType.where(name_id: name_id).first_or_create!
end

#Special Group Types
%w{veteran student senior not_special}.each do |name_id|
 SpecialGroup.where(name_id: name_id).first_or_create!
end

#Admin Users
%w{avi@significancelabs.org paul@significancelabs.org stephanie@significancelabs.org}.each do |email|
 AdminUser.where(email: email).first_or_create!(password: 'changeme', password_confirmation: 'changeme')
end

# banks and branches:
branches = {}
branches['Capital One'] = [
  {name:'Cypress Hill', street: '3345 Fulton Street', city: 'Brooklyn', state: 'NY', zipcode: '11208' },
  {name:'Bushwick', street: '315 Wyckoff Avenue', city: 'Brooklyn', state: 'NY', zipcode: '11237' },
  {name:'Sunset Park', street: '5001 5th Avenue', city: 'Brooklyn', state: 'NY', zipcode: '11220' },
  {name:'Jamaica', street: '161-01 Jamaica Avenue', city: 'Queens', state: 'NY', zipcode: '11432' },
  {name:'West Brighton', street: '386 Forest Avenue', city: 'Staten Island', state: 'NY', zipcode: '10301' },
]
branches['Bethex Federal Credit Union'] = [
  {name:'Conrad Walker', street: '20 East 179th Street', city: 'Bronx', state: 'NY', zipcode: '10453' },
]
branches['Ridgewood Savings Bank'] = [
  {name:'White Plains Road', street: '3824 White Plains Road', city: 'Bronx', state: 'NY', zipcode: '10467' },
]
branches['Popular Community Bank'] = [
  {name:'Third Avenue', street: '2923 Third Avenue', city: 'Bronx', state: 'NY', zipcode: '10455' },
  {name:'Graham Avenue', street: '15 Graham Avenue', city: 'Brooklyn', state: 'NY', zipcode: '11206' },
  {name:'East Houston', street: '310 East Houston St.', city: 'Manhattan', state: 'NY', zipcode: '10002' },
  {name:'Jackson Heights', street: '83-22 Baxter Avenue', city: 'Elmhurst', state: 'NY', zipcode: '11373' },
]
branches['Spring Bank'] = [
  {name:'Bronx', street: '69 East 167th St', city: 'Bronx', state: 'NY', zipcode: '10452' },
  {name:'Manhattan', street: '2049 Frederick Douglass Boulevard', city: 'Manhattan', state: 'NY', zipcode: '10026' },
]
branches['Amalgamated Bank'] = [
  {name:'Bed-Stuy', street: '1212 Fulton Street', city: 'Brooklyn', state: 'NY', zipcode: '11216' },
]
branches['M&T Bank'] = [
  {name:'Central', street: '2664 Atlantic Avenue', city: 'Brooklyn', state: 'NY', zipcode: '11207' },
]
branches['Carver Federal Savings Bank'] = [
  {name:'Malcolm X Boulevard', street: '142 Malcolm X Boulevard', city: 'Manhattan', state: 'NY', zipcode: '11433' },
]
branches["Lower East Side People's Federal Credit Union"] = [
  {name:'Avenue B', street: '37 Avenue B', city: 'Manhattan', state: 'NY', zipcode: '10009' },
]
branches["Neighborhood Trust Federal Credit Union"] = [
  {name:'St. Nicholas Avenue', street: '1112 St. Nicholas Avenue', city: 'Manhattan', state: 'NY', zipcode: '10032' },
]
branches["Union Settlement Federal Credit Union"] = [
  {name:'East 104th St', street: '237 East 104th St', city: 'Manhattan', state: 'NY', zipcode: '10029' },
]
branches['Chase'] = [
  {name:'9th Street', street: '444 5th Ave', city: 'Brooklyn', state: 'NY', zipcode: '11215' },
]

branches.each do |bank_name, bank_branches|
  # create a bank for each entry in branches
  bank = Bank.where(name: bank_name).first_or_create!(name: bank_name)
  bank_branches.each do |bank_branch|
    # create a branch
    branch = Branch.where(name: bank_branch[:name], bank_id: bank.id).first_or_initialize(bank_branch)
    branch.bank_id = bank.id
    branch.save!
    # create a safe account for that branch
    safe_type = AccountType.SAFE_ACCOUNT
    account = BankAccount.where(account_type_id: safe_type.id,
                                branch_id: branch.id).first_or_create!(name: "NYC Safe Account",
                                                                        account_type_id: safe_type.id,
                                                                        branch_id:branch.id)
  end
end

