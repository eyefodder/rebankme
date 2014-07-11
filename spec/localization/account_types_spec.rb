require 'spec_helper'
include Il8nSteps

describe 'Account Type Localizations' do
  let(:token_groups) {
   %w{prepay_card second_chance safe_account special_group regular_account credit_union}
  }
  let(:token_template){
    "
    name:
    overview:"
  }
  it_should_behave_like 'templated localized content'
end