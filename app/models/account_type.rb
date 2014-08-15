# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
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
  validates :name_id, presence: true
  validates :name_id, uniqueness: true

  def name
    I18n.t("#{name_id}.name")
  end
  # rubocop:disable Style/MethodName
  # because we want these to appear semantically as constants
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
  def self.STUDENT_ACCOUNT
    AccountType.where(name_id: 'student_account').first
  end
  def self.SENIORS_ACCOUNT
    AccountType.where(name_id: 'seniors_account').first
  end
  def self.VETERANS_ACCOUNT
    AccountType.where(name_id: 'veterans_account').first
  end
  # rubocop:enable Style/MethodName

  def special_group_account?
    %w(veterans_account seniors_account student_account).include? name_id
  end
end
