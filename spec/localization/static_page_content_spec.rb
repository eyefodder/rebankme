require 'spec_helper'
include Il8nSteps

describe 'Static Page Content Localizations' do

  let(:expected_tokens){
   "
    static:
      home:
        title:
        body_copy:
        account_finder_start:
    users:
      request_email:
        title:
        body_copy:
        skip_email_request:
      help_me_open:
        title:
        body_copy:
        what_you_need:
          title:
          things_needed:
        well_be_in_touch:
          title:
          body_copy:
    account_finder:
      start:
        title:
        body_copy:
      is_delinquent:
        title:
        question:
        question_options:
      has_predictable_income:
        title:
        question:
        action_yes:
        action_no:
      special_group:
        title:
        question:
        question_options:
      will_use_direct_deposit:
        title:
        question:
        action_yes:
        action_no:
      needs_debit_card:
        title:
        question:
        action_yes:
        action_no:
      account_type_found:
        title:
        overview_heading:
        why_we_chose_heading:
        cta:
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