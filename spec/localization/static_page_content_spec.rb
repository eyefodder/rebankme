require 'spec_helper'
include Il8nSteps

describe 'Static Page Content Localizations' do

  let(:expected_tokens){
   "
    static:
      home:
        title:
        account_finder_start:
    account_finder:
      start:
        title:
      is_delinquent:
        title:
        question:
      has_predictable_income:
        title:
        question:
      is_special_group:
        title:
        question:
      will_use_direct_deposit:
        title:
        question:
      needs_debit_card:
        title:
        question:
      account_type_found:
        title:
        overview_heading:
    forms:
      labels:
        enter_zipcode:
      actions:
        action_yes:
        action_no:
        start_over:"
  }
  it_should_behave_like 'localized content'

end