# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# == Schema Information
#
# Table name: bank_accounts
#
#  id              :integer          not null, primary key
#  account_type_id :integer
#  branch_id       :integer
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#
class BankAccount < ActiveRecord::Base
  validates :name, :account_type_id, :branch_id, presence: true
  belongs_to :branch
  belongs_to :account_type

  delegate :latitude, :longitude, to: :branch

  scope :ordered_by_branch_ids,
        ->(branch_ids) { order(branch_ordering_statement(branch_ids)) }
  scope :having_account_type,
        ->(account_type) { where(account_type_id: account_type.id) }
  scope :available_at_branches,
        ->(branch_ids) { where(branch_id: branch_ids) }

  def self.branch_ordering_statement(branch_ids)
    ret = 'CASE'
    branch_ids.each_with_index do |p, i|
      ret << " WHEN branch_id = '#{p}' THEN #{i}"
    end
    ret << ' END'
  end

  def self.accounts_near(user, account_type, limit = 6)
    branch_ids = Branch.near([user.latitude, user.longitude],
                             10,
                             order: 'distance').limit(limit).map(&:id)
    return [] if branch_ids.count == 0
    # rubocop:disable Style/LineLength
    # because although long, its a clear chain
    available_at_branches(branch_ids).having_account_type(account_type).ordered_by_branch_ids(branch_ids)
    # rubocop:enable Style/LineLength
  end
end
