# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
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
  validates :name, :bank_id, :zipcode, presence: true
  belongs_to :bank
  geocoded_by :full_address
  # rubocop:disable all
  # rubocop disabled as it wants to change proc { to do
  after_validation :geocode, if: lambda{ |obj|
    # will geocode if any of these properties changed...
    p = [:street_changed?, :city_changed?, :state_changed?, :zipcode_changed?]
    p.each do |property|
      return true if obj.send(property)
    end
    false
  }
  # rubocop:enable all

  def full_name
    "#{bank.name} - #{name}"
  end

  def full_address
    fields = [:street, :city, :state, :zipcode]
    res = ''
    fields.each do |element|
      res += "#{self[element]}, " unless self[element].blank?
    end
    res.chomp(', ')
  end
end
