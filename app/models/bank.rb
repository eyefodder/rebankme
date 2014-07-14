# == Schema Information
#
# Table name: banks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Bank < ActiveRecord::Base
  validates_presence_of :name
  validates :name, uniqueness: { case_sensitive: false }
end
