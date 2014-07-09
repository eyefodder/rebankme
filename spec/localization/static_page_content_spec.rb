require 'spec_helper'
include Il8nSteps

describe 'Static Page Content Localizations' do

  let(:expected_tokens){
    "static:
      home:
        title:"
  }
  it_should_behave_like 'localized content'

end