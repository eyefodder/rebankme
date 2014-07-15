# == Schema Information
#
# Table name: branches
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address_id :integer
#  telephone  :string(255)
#  hours      :string(255)
#  bank_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Branch < ActiveRecord::Base
  validates_presence_of :name, :address_id, :bank_id
  belongs_to :address
  belongs_to :bank
  accepts_nested_attributes_for :address, allow_destroy: false
end
