
include PageContentSteps
include AdminSteps
include DataEntrySteps

include EditableObjectSteps

describe 'Branch Pages', :type => :request do
  let (:required_properties) {[:name]}

  let(:type){:branch}
  let(:admin_paths) {[:index, :new, :edit]}

  subject {page}

  include_context 'has index pages'
  include_context 'has admin only pages'

  describe 'new' do
    pending 'havent sorted testing nested forms' do
      include_context '#new creates objects'
    end
  end

end