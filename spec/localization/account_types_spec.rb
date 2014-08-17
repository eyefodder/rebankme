# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'
include Il8nSteps

describe 'Account Type Localizations' do

  describe 'account types' do
    it_should_behave_like 'templated localized content' do
      let(:token_groups) do
        %w(prepay_card second_chance safe_account
           special_group regular_account credit_union)
      end
      let(:token_template)do
        "
        name:
        overview:"
      end
    end
  end
  describe 'deciding factors' do
    it_should_behave_like 'templated localized content' do
      let(:token_groups) do
        %w(deciding_factors.positive deciding_factors.negative)
      end
      let(:token_template)do
        "
       is_delinquent:
       has_predictable_income:
       in_new_york_city:
       is_special_group:
       will_use_direct_deposit:
       needs_debit_card:"
      end
    end
  end
end
