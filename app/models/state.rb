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
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false
  validates_presence_of :code
  validates_uniqueness_of :code, case_sensitive: false

  def chase_state?
    %w{AZ CA CO CT FL GA HI ID IL IN KY LA MA MI NJ NV NY OH OK OR TX UT WA WI WV}.include? code
  end
end
