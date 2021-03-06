# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)

include PageContentSteps
include AdminSteps
include DataEntrySteps

include EditableObjectSteps

describe 'Branch Pages', type: :request do
  let(:required_properties) { [:name, { zipcode: { valid: '11205' } }] }
  let(:post_create_path) { branches_path }
  let(:type) { :branch }
  let(:admin_paths) { [:index, :new, :edit] }

  subject { page }

  include_context 'has index pages'
  include_context 'has admin only pages'

  describe 'new' do
    include_context '#new creates objects'
  end

  describe 'edit' do
    include_context '#edit edits objects'
  end

end
