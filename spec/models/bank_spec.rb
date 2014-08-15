# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# == Schema Information
#
# Table name: banks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Bank do
  let(:bank) { build(:bank) }
  describe 'validations' do
    it 'should require a name' do
      # expect(bank).to validate_presence_of(:name)
    end
    it 'should require a unique name' do
      expect(bank).to validate_uniqueness_of(:name).case_insensitive
    end
  end
end
