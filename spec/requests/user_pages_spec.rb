# require 'spec_helper'

include PageContentSteps
include DataEntrySteps
include PathMatchers

describe 'User Pages', :type => :request do
  let(:user) {create(:user)}


  subject {page}

  describe 'request email' do
    let(:redirect_path){account_finder_start_path}
    let(:good_email){'eyefodder@gmail.com'}
    before do
      visit request_user_email_path(user,redirect_path: redirect_path )
    end
    it 'should show user email entry' do
      expect(page).to have_css('#user_email')
    end
    it 'should offer a link to skip entry' do
      expect(page).to have_css('#skip-email-request')
    end
    describe 'entering a good email' do
      before do
        fill_in :email, with: good_email
        click_submit_button
      end
      it 'should be on redirect_path' do
        expect(current_path).to eq(redirect_path)
      end
      it 'should have updated the email' do
        expect(user.reload.email).to eq(good_email)
      end
    end
    describe 'entering a bad email' do
      before do
        fill_in :email, with: 'bademail'
        click_submit_button
      end
      it 'should be on request email path' do
        expect(current_path).to be_request_email_path
      end
      it 'should display an error' do
        expect(page).to display_error_message(I18n.t('errors.messages.invalid_email_format'))
      end
    end
    describe 'clicking skip' do
      before do
        click_link('skip-email-request')
      end
      it 'should go to redirect_path' do
        expect(current_path).to eq(redirect_path)
      end
    end

  end

end