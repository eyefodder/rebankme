# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  zipcode                 :string(255)
#  is_delinquent           :boolean
#  is_special_group        :boolean
#  will_use_direct_deposit :boolean
#  has_predictable_income  :boolean
#  needs_debit_card        :boolean
#  created_at              :datetime
#  updated_at              :datetime
#

require 'spec_helper'

describe User do
  let(:user) {build(:user)}
  describe '#in_new_york_city' do
    it 'returns false if zip not set' do
      expect(user.in_new_york_city?).to be_false
    end

    it 'returns false if zip outside NYC' do
      user.zipcode = '90210'
      expect(user.in_new_york_city?).to be_false
    end

    it 'returns true for all of the zipcodes in NYC' do
      %w{10001 10002 10003 10004 10005 10006 10007 10009 10010 10011 10012 10013 10014
        10016 10017 10018 10019 10020 10021 10022 10023 10024 10025 10026 10027 10028
        10029 10030 10031 10032 10033 10034 10035 10036 10037 10038 10039 10040 10044
        10128 10280 10301 10302 10303 10304 10305 10306 10307 10308 10309 10310 10312
        10314 10451 10452 10453 10454 10455 10456 10457 10458 10459 10460 10461 10462
        10463 10464 10465 10466 10467 10468 10469 10470 10471 10472 10473 10474 10475
        11004 11005 11101 11102 11103 11104 11105 11106 11201 11203 11204 11205 11206
        11207 11208 11209 11210 11211 11212 11213 11214 11215 11216 11217 11218 11219
        11220 11221 11222 11223 11224 11225 11226 11228 11229 11230 11231 11232 11233
        11234 11235 11236 11237 11238 11239 11354 11355 11356 11357 11358 11359 11360
        11361 11362 11363 11364 11365 11366 11367 11368 11369 11370 11372 11373 11374
        11375 11377 11378 11379 11385 11411 11412 11413 11414 11415 11416 11417 11418
        11419 11420 11421 11422 11423 11426 11427 11428 11429 11432 11433 11434 11435
        11436 11691 11692 11693 11694 11695 11697}.each do |zip|
          user.zipcode = zip
          expect(user.in_new_york_city?).to be_true, "expected user with zip #{zip} to be in NYC"

        end


    end
  end
end
