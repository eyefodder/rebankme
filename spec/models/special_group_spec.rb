# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# == Schema Information
#
# Table name: special_groups
#
#  id         :integer          not null, primary key
#  name_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe SpecialGroup do

  shared_examples 'a predefined type' do
    it 'exists' do
      expect(special_group).to_not be_nil
      expect(special_group).to be_an(SpecialGroup)
    end
    it 'has a name id' do
      expect(special_group.name_id).to eq name_id
    end

    # it 'has a value for the name' do
    #   there_should_be_a_translation_for("#{special_group.name_id}.name")
    # end
  end

  let(:special_group) { build(:special_group) }
  it 'should require a name' do
    expect(special_group).to validate_presence_of(:name_id)
  end
  it 'should require a unique name' do
    expect(special_group).to validate_uniqueness_of(:name_id)
  end

  describe 'seeded content' do
    it 'should have seeded types' do
      %w(veteran student senior not_special).each do |expected|
        expect(SpecialGroup.find_by(name_id: expected)).not_to be_nil, "Expected to find a Special group with name_id: #{expected}"
      end
    end
    describe 'not special' do
      let(:special_group) { SpecialGroup.NOT_SPECIAL }
      it_behaves_like 'a predefined type' do
        let(:name_id) { 'not_special' }
      end
    end
    describe 'student' do
      let(:special_group) { SpecialGroup.STUDENT }
      it_behaves_like 'a predefined type' do
        let(:name_id) { 'student' }
      end
    end
    describe 'veteran' do
      let(:special_group) { SpecialGroup.VETERAN }
      it_behaves_like 'a predefined type' do
        let(:name_id) { 'veteran' }
      end
    end
    describe 'senior' do
      let(:special_group) { SpecialGroup.SENIOR }
      it_behaves_like 'a predefined type' do
        let(:name_id) { 'senior' }
      end
    end
  end

end
