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
    forms:
      labels:
        enter_zipcode:"
  }
  it_should_behave_like 'localized content'

end