# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
account_types = AccountType.create([{name_id:'prepay_card'},
                                    {name_id:'second_chance'},
                                    {name_id:'safe_account'},
                                    {name_id:'special_group'},
                                    {name_id:'regular_account'},
                                    {name_id:'credit_union'},
                                    ])

