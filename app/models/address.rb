# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  street     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zipcode    :string(255)
#  latitude   :float
#  longitude  :float
#  created_at :datetime
#  updated_at :datetime
#

class Address < ActiveRecord::Base
    validates_presence_of :zipcode

  geocoded_by :full_address
  after_validation :geocode, :if => lambda{ |obj|
      obj.street_changed? || obj.city_changed? || obj.state_changed? || obj.zipcode_changed?

       }

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
