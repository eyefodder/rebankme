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

require 'spec_helper'

describe State do
  let(:state) { build(:state) }
  describe 'validations' do
    it 'validates presence of name' do
      expect(state).to validate_presence_of(:name)
    end
    it 'validates uniqueness of name' do
      expect(state).to validate_uniqueness_of(:name).case_insensitive
    end
    it 'validates presence of code' do
      expect(state).to validate_presence_of(:code)
    end
    it 'validates uniqueness of code' do
      expect(state).to validate_uniqueness_of(:code).case_insensitive
    end
  end

  describe 'chase_state?' do
    let(:in_states) { %w(AZ CA CO CT FL GA HI ID IL IN KY LA MA MI NJ NV NY OH OK OR TX UT WA WI WV) }
    it 'returns false for the rest' do
      State.all.each do |state|
        expected = in_states.include?(state.code) ? true : false
        expect(state.chase_state?).to eq(expected), "Expected chase_state for #{state.code} to be #{expected}"
      end
    end
  end
  describe 'us_bank_states?' do
    let(:in_states) { %w(AZ AR CA CO ID IL IN IA KA KY MN MO MT NE NV ND OH OR SD TN UT WA WI WY) }
    it 'returns false for the rest' do
      State.all.each do |state|
        expected = in_states.include?(state.code) ? true : false
        expect(state.us_bank_state?).to eq(expected), "Expected us_bank_state? for #{state.code} to be #{expected}"
      end
    end
  end

  describe 'seeded content' do
    let(:states)  do[{ code: 'AL', name: 'Alabama' },
                     { code: 'LA', name: 'Louisiana' },
                     { code: 'OH', name: 'Ohio' },
                     { code: 'AK', name: 'Alaska' },
                     { code: 'ME', name: 'Maine' },
                     { code: 'OK', name: 'Oklahoma' },
                     { code: 'AZ', name: 'Arizona' },
                     { code: 'MD', name: 'Maryland' },
                     { code: 'OR', name: 'Oregon' },
                     { code: 'AR', name: 'Arkansas' },
                     { code: 'MA', name: 'Massachusetts' },
                     { code: 'PA', name: 'Pennsylvania' },
                     { code: 'CA', name: 'California' },
                     { code: 'MI', name: 'Michigan' },
                     { code: 'RI', name: 'Rhode Island' },
                     { code: 'CO', name: 'Colorado' },
                     { code: 'MN', name: 'Minnesota' },
                     { code: 'SC', name: 'South Carolina' },
                     { code: 'CT', name: 'Connecticut' },
                     { code: 'MS', name: 'Mississippi' },
                     { code: 'SD', name: 'South Dakota' },
                     { code: 'DE', name: 'Delaware' },
                     { code: 'MO', name: 'Missouri' },
                     { code: 'TN', name: 'Tennessee' },
                     { code: 'FL', name: 'Florida' },
                     { code: 'MT', name: 'Montana' },
                     { code: 'TX', name: 'Texas' },
                     { code: 'GA', name: 'Georgia' },
                     { code: 'NE', name: 'Nebraska' },
                     { code: 'UT', name: 'Utah' },
                     { code: 'HI', name: 'Hawaii' },
                     { code: 'NV', name: 'Nevada' },
                     { code: 'VT', name: 'Vermont' },
                     { code: 'ID', name: 'Idaho' },
                     { code: 'NH', name: 'New Hampshire' },
                     { code: 'VA', name: 'Virginia' },
                     { code: 'IL', name: 'Illinois' },
                     { code: 'NJ', name: 'New Jersey' },
                     { code: 'WA', name: 'Washington' },
                     { code: 'IN', name: 'Indiana' },
                     { code: 'NM', name: 'New Mexico' },
                     { code: 'WV', name: 'West Virginia' },
                     { code: 'IA', name: 'Iowa' },
                     { code: 'NY', name: 'New York' },
                     { code: 'WI', name: 'Wisconsin' },
                     { code: 'KS', name: 'Kansas' },
                     { code: 'NC', name: 'North Carolina' },
                     { code: 'WY', name: 'Wyoming' },
                     { code: 'KY', name: 'Kentucky' },
                     { code: 'ND', name: 'North Dakota' },]end

    it 'has an entry for each state' do
    states.each do |state|
     expect(State.find_by(name: state[:name], code: state[:code])).not_to be_nil, "Couldnt find a state with code #{state[:code]} and name #{state[:name]}"
   end
  end

  end
end
