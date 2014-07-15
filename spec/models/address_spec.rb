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

require 'spec_helper'

describe Address do
  let(:address){build(:address)}
  describe 'validations' do
    it 'should require a zipcode' do
      expect(address).to validate_presence_of(:zipcode)
    end
  end

  describe 'geocoding' do
    before do
      address.zipcode = '11205' #values in spec helper
      address.valid?
    end
    it 'should have set the latitude' do
      expect(address.latitude).to eq 43.6047275 #values in spec helper
    end
    it 'should have set the longitude' do
      expect(address.longitude).to eq 3.941479699999999 #values in spec helper
    end
  end

  describe 'full_address' do
    let(:street) {'118 E 10th st'}
    let(:city) {'New York'}
    let(:state) {'NY'}
    it 'handles zip only' do
      expect(address.full_address).to eq '11205'
    end
    it 'handles street and zip' do
      address.street = street
      expect(address.full_address).to eq "#{street}, 11205"
    end
    it 'handles street and city and zip' do
      address.street = street
      address.city = city
      expect(address.full_address).to eq "#{street}, #{city}, 11205"
    end
    it 'handles street and state and zip' do
      address.street = street
      address.state = state
      expect(address.full_address).to eq "#{street}, #{state}, 11205"
    end
  end
end

