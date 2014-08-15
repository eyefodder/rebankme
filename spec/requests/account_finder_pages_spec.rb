# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)

include PageContentSteps
include AccountFinderSteps
include DataEntrySteps
include PathMatchers
include ActionView::Helpers::TextHelper

describe 'Account Finder Pages', type: :request do

  subject { page }

  describe 'Safe Account' do
    let(:good_zipcode) { '11205' }
    before do
      visit account_finder_start_path

      # enter zipcode
      populate_form_field(:user, :zipcode, good_zipcode)

      click_submit_button

      # yes to delinquent
      click_yes_button

      # yes to regular income
      click_yes_button
    end
    it 'should display a find me the right account button' do
      expect(page).to have_find_account_button(:safe_account)
    end
    describe 'clicking the button' do
      before do
        click_link('account-finder-drilldown-button')
      end
      it 'will display results page' do
        expect(current_path).to be_find_account_path
      end
    end

    # describe 'fin'

  end

  describe 'find account page' do
    let(:good_zipcode) { '11205' }
    let(:account_1) { create(:bank_account, account_type: AccountType.SAFE_ACCOUNT) }
    let(:account_2) { create(:bank_account, account_type: AccountType.PREPAY_CARD) }
    let(:account_3) { create(:bank_account, account_type: AccountType.SAFE_ACCOUNT) }

    before do
      BankAccount.destroy_all

      BankAccount.stub(:accounts_near).and_return([account_1, account_3])

      account_1
      account_2
      account_3

      visit account_finder_start_path
      # enter zipcode
      populate_form_field(:user, :zipcode, good_zipcode)
      click_submit_button
      # yes to delinquent
      click_yes_button
      # yes to regular income
      click_yes_button
      # view results
      click_link('account-finder-drilldown-button')
    end

    it 'recommends the closest result' do

      within('div.recommended_option') do
        expect(page).to have_css('h4', text: account_1.name)
        expect(page).to have_css('div.recommend-branch-name', text: account_1.branch.full_name)
        expect(page).to have_css('div.recommended-branch-address', text: account_1.branch.full_address)
      end
    end

    it 'displays other options heading' do
      within('div.other-branches') do
        expect(page).to have_css('h4', text: I18n.t('account_finder.account_type.safe_account.geolocated_results_heading', zipcode: good_zipcode))
      end
    end
    it 'displays the recommended result as selected' do
      within('a.recommended_option.selected_option') do
        expect(page).to have_css('div', text: account_1.branch.full_name)
      end
    end
    describe 'clicking the second option' do
      before do
        click_link("select_account_#{account_3.id}")
      end
      it 'displays new bank as selected' do
        within('a.selected_option') do
          expect(page).to have_css('div', text: account_3.branch.full_name)
        end
      end
    end

  end

  describe 'Start' do
    let(:good_zipcode) { '11205' }
    let(:non_nyc_zipcode) { '90210' }
    before do
      visit account_finder_start_path
    end
    describe 'page content' do
      it 'has expected content' do
        expect(page).to display_account_finder_content(:start)
      end
      it 'has a zipcode entry form' do
        expect(page).to have_form_for(:user).with_field(:zipcode)
      end
    end

    describe 'entering a non NYC zipcode' do
      before do
        populate_form_field(:user, :zipcode, non_nyc_zipcode)
        click_submit_button
      end
      describe '> is not delinquent > is not special group' do
        before do
          click_no_button # is not delinquent
          click_no_button # is not special
        end
        describe '> will not direct Deposit' do
          it_behaves_like 'a question page' do
            let(:question_token) { :will_use_direct_deposit }
            let(:no_destination) { { account_type: :credit_union } }
            let(:yes_destination) { { account_type: :regular_account } }
          end
        end
      end
      describe '> is delinquent' do
        before do
          click_yes_button
        end
        describe '> has predictable income ' do
          it 'temporarily sends yes also to prepay_card' do
            click_yes_button
            pending('non nyc ppl should eventually get sent to second chance accounts') do
              expect(page).to display_account_type_found(:second_chance)
            end
          end
          it_behaves_like 'a question page' do
            let(:question_token) { :has_predictable_income }
            let(:no_destination) { { account_type: :prepay_card } }
            let(:yes_destination) { { account_type: :prepay_card } }
          end
        end
      end
    end

    describe '> is user delinquent:' do
      before do
        populate_form_field(:user, :zipcode, good_zipcode)
        click_submit_button
      end
      it_behaves_like 'a question page' do
        let(:question_token) { :is_delinquent }
        let(:yes_destination) { :has_predictable_income }
        let(:no_destination) { :special_group }
      end
      describe 'YES: > Has predictable income' do
        before do
          click_yes_button
        end
        it_behaves_like 'a question page' do
          let(:question_token) { :has_predictable_income }
          let(:no_destination) { { account_type: :prepay_card } }
          let(:yes_destination) { { account_type: :safe_account } }
        end
      end
      describe 'NO: > Is Special Group' do
        before do
          click_no_button
        end
        it_behaves_like 'a multi choice question page' do
          let(:question_token) { :special_group }
          let(:no_destination) { :will_use_direct_deposit }
          let(:yes_destination) { { account_type: :special_group } }
        end

        describe 'NO: > Will Direct Deposit?' do
          before do
            click_no_button
          end
          it_behaves_like 'a question page' do
            let(:question_token) { :will_use_direct_deposit }
            let(:no_destination) { :needs_debit_card }
            let(:yes_destination) { { account_type: :regular_account } }
          end
          describe 'NO: > Needs Debit Card?' do
            before do
              click_no_button
            end
            it_behaves_like 'a question page' do
              let(:question_token) { :needs_debit_card }
              let(:no_destination) { { account_type: :safe_account } }
              let(:yes_destination) { { account_type: :credit_union } }
            end
          end
        end
      end
    end

    describe 'Entering a zipcode' do
      describe 'with valid 5 digit code' do
        it_behaves_like 'a successful zipcode entry' do
          let(:zipcode) { good_zipcode }
        end
      end
      describe 'with valid 9 digit code' do
        it_behaves_like 'a successful zipcode entry' do
          let(:zipcode) { '11205-4407' }
        end
      end
      describe 'with valid zipcode format but foreign zip' do
        it_behaves_like 'a failed zipcode entry' do
          let(:expected_error) { I18n.t('errors.messages.zipcode_wrong_country') }
          let(:zipcode) { '34000' }
        end
      end
      describe 'with valid zipcode format but non existant zip' do
        it_behaves_like 'a failed zipcode entry' do
          let(:expected_error) { I18n.t('errors.messages.zipcode_not_found') }
          let(:zipcode) { '00000' }
        end
      end
      describe 'with invalid zipcode format' do
        it_behaves_like 'a failed zipcode entry' do
          let(:expected_error) { I18n.t('errors.messages.invalid_zipcode_format') }
          let(:zipcode) { nil }
        end
      end
    end

  end

end
