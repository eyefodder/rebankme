# require 'spec_helper'

include PageContentSteps
include DataEntrySteps
include PathMatchers

include ActionView::Helpers::TextHelper





describe 'User Pages', :type => :request do
  let(:user) {create(:user)}
  let(:good_email){'eyefodder@gmail.com'}


  subject {page}




  describe 'account_opening_assistance' do
    let(:account_type){AccountType.SAFE_ACCOUNT}

    describe 'a user with no email' do
      before do
        visit account_opening_assistance_path(user, account_type)
      end
      it 'goes to the request email page' do
        expect(current_path).to be_request_email_path
      end
      it 'displays no skip messages' do
        expect(page).not_to have_css('#skip-email-request')
      end
      describe 'and then entering email' do
        before do
          fill_in :email, with: good_email
          click_submit_button
        end
        it 'displays the help me open page' do
          expect(current_path).to eq account_opening_assistance_path(user, account_type)
        end
      end
    end

    describe 'tells the backend' do
      before do
        user.email = good_email
        user.save!
      end
      it 'via email' do
        expect{visit account_opening_assistance_path(user, account_type)}.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    describe 'a user with email' do
      before do
        user.email = good_email
        user.save!
        visit account_opening_assistance_path(user, account_type)
      end
      it 'displays the help me open page' do
        expect(current_path).to eq account_opening_assistance_path(user, account_type)
      end

    end

    describe 'page' do
      before do
        user.email = good_email
        user.save!
        visit account_opening_assistance_path(user, account_type)
      end

      it 'has a title' do
        expected_title = I18n.t('users.help_me_open.page_title', product: account_type.name)
        expected_heading = I18n.t('users.help_me_open.heading', product: account_type.name)
        expect(page).to have_page_title(expected_title)
        expect(page).to have_page_heading(expected_heading)
      end
      it 'has body copy' do
        content = I18n.t('users.help_me_open.body_copy', product: account_type.name)
        expect(page).to have_body_copy(content).with_id('intro_text')
      end
      it 'has a list of required documents' do
        expect(page).to have_css('h3', text: I18n.t('users.help_me_open.what_you_need.title'))
        bullets = I18n.t('users.help_me_open.what_you_need.things_needed', default:{}).to_a.map{|obj| obj[1]}
        bullets.each  do |bullet|
          expect(page).to have_css('li', text: bullet)
        end
      end
      it "has a we'll be in touch section" do
        expect(page).to have_css('h3', text: I18n.t('users.help_me_open.well_be_in_touch.title'))
        content = I18n.t('users.help_me_open.well_be_in_touch.body_copy')
        expect(page).to have_body_copy(content).with_id('in_touch_text')
      end

    end

  end

  describe 'request email' do
    let(:redirect_path){account_finder_start_path}

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