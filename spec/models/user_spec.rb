# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  zipcode                 :string(255)
#  is_delinquent           :boolean
#  will_use_direct_deposit :boolean
#  has_predictable_income  :boolean
#  needs_debit_card        :boolean
#  created_at              :datetime
#  updated_at              :datetime
#  latitude                :float
#  longitude               :float
#  email                   :string(255)
#  special_group_id        :integer
#  state_id                :integer
#

require 'spec_helper'

include Il8nSteps

describe User do
  let(:user) { build(:user) }

  RSpec::Matchers.define :have_a_translation do |_expected|
    match do |actual|
      I18n.t(actual) != "translation missing: en.#{actual}"
    end
    failure_message_for_should do |actual|
      "expected that #{actual} would be present in one of the locale files"
    end

    failure_message_for_should_not do |actual|
      "expected that #{actual} would not be " \
      'present in one of the locale files'
    end

    description do
      'have a translation'
    end
  end

  describe '#answered_any_questions?' do
    it 'returns false if no questions answered' do
      expect(user.answered_any_questions?).to be_false
    end
    it 'returns true if any boolean questions answered' do
      questions = [:is_delinquent,
                   :will_use_direct_deposit,
                   :has_predictable_income,
                   :needs_debit_card]
      questions.each do |property|
        fail_true = "#{property} set should return true"
        fail_nil = "#{property} unset should return false"
        user[property] = true
        expect(user.answered_any_questions?).to be_true, fail_true
        user[property] = false
        expect(user.answered_any_questions?).to be_true, fail_true
        user[property] = nil
        expect(user.answered_any_questions?).to be_false, fail_nil
      end
    end
    it 'returns true if a special group is set' do
      user.special_group = SpecialGroup.VETERAN
      expect(user.answered_any_questions?).to be_true
    end
    it 'returns true if a special group is not special' do
      user.special_group = SpecialGroup.NOT_SPECIAL
      expect(user.answered_any_questions?).to be_true
    end
  end

  describe 'associations' do
    it 'should belong to special group' do
      expect(user).to belong_to(:special_group)
    end
    it 'should belong to state' do
      expect(user).to belong_to(:state)
    end
  end

  describe 'special_group?' do
    let(:special_group) { create(:special_group) }
    it 'should have special_group? be null if nothing set' do
      expect(user.special_group?).to be_nil
    end
    it 'should have special_group? be true if a special group id set' do
      user.special_group = special_group
      # user.save!
      expect(user.special_group?).to be_true
    end
    it 'should have special_group? be false if SpecialGroup.NOT_SPECIAL' do
      user.special_group = SpecialGroup.NOT_SPECIAL
      # user.save!
      expect(user.special_group?).to be_false
    end
  end

  describe '#set_option' do
    describe 'setting a special group option' do
      let(:special_group) { create(:special_group) }
      before do
        user.set_option('special_group', special_group.name_id)
        user.save!
      end
      it 'sets a special group' do
        expect(user.special_group).to eq(special_group)
      end
      it 'returns true for special_group?' do
        expect(user.special_group?).to be_true
      end
    end
    describe 'when setting special group option as false' do
      before do
        user.set_option('special_group', 'false')
        user.save!
      end
      it 'sets special_group to be NOT_SPECIAL' do
        expect(user.special_group).to eq(SpecialGroup.NOT_SPECIAL)
      end
      it 'resturns false for special_group?' do
        expect(user.special_group?).to be_false
      end
    end
  end

  describe '#distance_to' do
    let(:bk_usr) do
      create(:user,
             latitude: 40.6945036,
             longitude: -73.9565551,
             zipcode: '11205')
    end
    let(:bronx_branch) do
      create(:branch,
             latitude: 40.8522159,
             longitude: -73.907912,
             zipcode: '10453')
    end
    let(:bronx_safe_account) do
      create(:bank_account,
             branch: bronx_branch,
             name: 'bronx safe account')
    end
    it 'gives distance_to a branch' do
      expect(bk_usr.distance_to(bronx_branch)).to be_within(0.01).of(11.19)
    end
  end

  describe 'zipcode validation' do
    let(:nonexistant_zip) { '00000' }
    let(:incorrect_format_zip) { 'qqww2' }
    let(:non_us_zip) { 'ec1y0st' }
    let(:non_us_zip_with_us_format) { '34000' }
    before do

    end
    it 'isnt valid if no zipcode set' do
      user.zipcode = nil
      expect(user).to_not be_valid
    end

    it 'isnt valid if junk string set' do
      user.zipcode = incorrect_format_zip
      expect(user).to_not be_valid
      error = I18n.t('errors.messages.invalid_zipcode_format')
      expect(user.errors_on(:zipcode)).to include(error)
    end
    it 'isnt valid with a non us zipcode' do
      user.zipcode = non_us_zip
      expect(user).to_not be_valid
      error = I18n.t('errors.messages.invalid_zipcode_format')
      expect(user.errors_on(:zipcode)).to include(error)
      not_found = I18n.t('errors.messages.zipcode_not_found')
      expect(user.errors_on(:zipcode)).not_to include(not_found)
    end
    it 'isnt valid with a valid format but non existant code' do
      user.zipcode = nonexistant_zip
      expect(user).to_not be_valid
      error = I18n.t('errors.messages.zipcode_not_found')
      expect(user.errors_on(:zipcode)).to include(error)
    end
    it 'isnt valid with a US formatted zip that belongs to another country' do
      user.zipcode = non_us_zip_with_us_format
      expect(user).to_not be_valid
      error = I18n.t('errors.messages.zipcode_wrong_country')
      expect(user.errors_on(:zipcode)).to include(error)
    end
    it 'has a localized error message for wrong format' do
      expect('errors.messages.invalid_zipcode_format').to have_a_translation
    end
    it 'has a localized error message for not found' do
      expect('errors.messages.zipcode_not_found').to have_a_translation
    end
    it 'has a localized error message for wrong country' do
      expect('errors.messages.zipcode_wrong_country').to have_a_translation
    end
  end
  describe '#in_new_york_city' do
    it 'returns false if zip not set' do
      user.zipcode = nil
      expect(user.in_new_york_city?).to be_false
    end

    it 'returns false if zip outside NYC' do
      user.zipcode = '90210'
      expect(user.in_new_york_city?).to be_false
    end

    it 'returns true for all of the zipcodes in NYC' do
      zips = %w(10001 10002 10003 10004 10005 10006 10007 10009 10010 10032
                10011 10012 10013 10014 10016 10017 10018 10019 10020 10021
                10022 10023 10024 10025 10026 10027 10028 10029 10030 10031
                10033 10034 10035 10036 10037 10038 10039 10040 10044 10128
                10280 10301 10302 10303 10304 10305 10306 10307 10308 10309
                10310 10312 10314 10451 10452 10453 10454 10455 10456 10457
                10458 10459 10460 10461 10462 10463 10464 10465 10466 10467
                10468 10469 10470 10471 10472 10473 10474 10475 11004 11005
                11101 11102 11103 11104 11105 11106 11201 11203 11204 11205
                11206 11207 11208 11209 11210 11211 11212 11213 11214 11215
                11216 11217 11218 11219 11220 11221 11222 11223 11224 11225
                11226 11228 11229 11230 11231 11232 11233 11234 11235 11236
                11238 11239 11354 11355 11356 11357 11358 11359 11360 11361
                11363 11364 11365 11366 11367 11368 11369 11370 11372 11373
                11375 11377 11378 11379 11385 11411 11412 11413 11414 11415
                11417 11418 11419 11420 11421 11422 11423 11426 11427 11428
                11432 11433 11434 11435 11436 11691 11692 11693 11694 11695
                11237 11362 11374 11416 11429 11697
             )
      zips.each do |zip|
        user.zipcode = zip
        expect(user.in_new_york_city?).to be_true,
                                          'expected user with zip ' \
                                          "#{zip} to be in NYC"
      end
    end
  end
end
