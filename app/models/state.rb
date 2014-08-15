# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class State < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :code, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  CHASE_STATES = %w(AZ CA CO CT FL GA HI ID IL IN KY
                    LA MA MI NJ NV NY OH OK OR TX UT WA WI WV)
  US_BANK_STATES = %w(AZ AR CA CO ID IL IN IA KA KY MN MO
                      MT NE NV ND OH OR SD TN UT WA WI WY)

  def chase_state?
    CHASE_STATES.include? code
  end

  def us_bank_state?
    US_BANK_STATES.include? code
  end
end
