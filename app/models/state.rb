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
end
