# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)

include PageContentSteps
include AdminSteps
include DataEntrySteps
include EditableObjectSteps




describe 'Bank Account Pages', :type => :request do
  let!(:branch){create(:branch)}
  let!(:account_type){AccountType.PREPAY_CARD}
  let(:required_properties) {[:name ]}

  # NB - these are also required, but as there is no 'null' option it should always select one...
  #                              {:branch_id =>{:valid =>branch.full_name, :field_type => :select, :expected_update_value => branch.id }},
                              # {:account_type_id =>{:valid =>account_type.name, :field_type => :select, :expected_update_value => account_type.id }}

  let(:type){:bank_account}
  let(:post_create_path){bank_accounts_path}
  let(:admin_paths) {[:index, :new, :edit]}
  subject {page}


  include_context 'has index pages'
  include_context 'has admin only pages'
  describe 'new' do
    include_context '#new creates objects'
  end


  describe 'edit' do
    include_context '#edit edits objects'
  end

end