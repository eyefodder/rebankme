require 'spec_helper'
include Il8nSteps

describe 'Static Page Content Localizations' do

  let(:expected_tokens){
   "
    static:
      home:
        title:
        account_finder_start:
    users:
      request_email:
        title:
        body_copy:
        opt_out:
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
        why_we_chose_heading:
    forms:
      labels:
        enter_zipcode:
        enter_email:
      actions:
        action_yes:
        action_no:
        action_go:
        start_over:"
  }
  it_should_behave_like 'localized content'

end