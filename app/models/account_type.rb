# == Schema Information
#
# Table name: account_types
#
#  id         :integer          not null, primary key
#  name_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class AccountType < ActiveRecord::Base
  validates_presence_of :name_id
  validates_uniqueness_of :name_id

  def self.PREPAY_CARD
    AccountType.where(name_id: 'prepay_card').first
  end

  def self.SECOND_CHANCE
    AccountType.where(name_id: 'second_chance').first
  end
  def self.SAFE_ACCOUNT
    AccountType.where(name_id: 'safe_account').first
  end
  def self.SPECIAL_GROUP
    AccountType.where(name_id: 'special_group').first
  end
  def self.REGULAR_ACCOUNT
    AccountType.where(name_id: 'regular_account').first
  end
  def self.CREDIT_UNION
    AccountType.where(name_id: 'credit_union').first
  end
end
