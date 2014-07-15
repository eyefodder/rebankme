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
#  street     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zipcode    :string(255)
#  latitude   :float
#  longitude  :float
#

class Branch < ActiveRecord::Base
  validates_presence_of :name, :bank_id, :zipcode
  belongs_to :bank
  geocoded_by :full_address
  after_validation :geocode, :if => lambda{ |obj|
    obj.street_changed? || obj.city_changed? || obj.state_changed? || obj.zipcode_changed?
  }
  # accepts_nested_attributes_for :address, allow_destroy: false

  def full_name
    "#{bank.name} - #{name}"
  end

  def full_address
    res = ''
    [:street, :city, :state, :zipcode].each do |element|
      unless self[element].blank?
        res = res + "#{self[element]}, "
      end
    end
    res.chomp(', ')
  end


end
