require 'spec_helper'
include Il8nSteps

describe 'Errors Localizations' do
  let(:expected_tokens){
    "errors:
      messages:
        zipcode_not_found:
        invalid_zipcode_format:"
  }
  it_should_behave_like 'localized content'

end