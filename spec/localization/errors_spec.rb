# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'
include Il8nSteps

describe 'Errors Localizations' do
  let(:expected_tokens)do
    "errors:
      messages:
        zipcode_not_found:
        invalid_zipcode_format:
        zipcode_wrong_country:
        invalid_email_format:"
  end
  it_should_behave_like 'localized content'

end
