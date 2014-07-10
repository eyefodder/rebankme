
include PageContentSteps
describe 'Account Finder Pages', :type => :request do

  subject {page}


  describe 'Start' do
    let(:good_zipcode) {'11205'}
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

    describe '> is user delinquent:' do
      before do
        populate_form_field(:user, :zipcode, good_zipcode)
        click_button('submit')
      end
      describe 'page content' do
        it 'has expected content' do
          expect(page).to display_account_finder_content(:is_delinquent)
        end
        it 'has correct question' do
          expect(page).to display_account_finder_question(:is_delinquent)
        end
        it 'has yes / no buttons' do
          expect(page).to display_choice_buttons([:yes, :no])
        end
      end
      describe 'clicking yes' do
        before do
          click_button(:yes)
        end
        xit 'goes to the predictable income page' do
           expect(page).to display_account_finder_content(:has_predictable_income)
        end
      end

    end

    RSpec::Matchers.define :display_choice_buttons do |choices|
      failure_message_for_should do |actual|
        "expected to find a button labelled '#{choice}'"
      end
      match do |page|
        choices.each do |choice|
          have_selector(:link_or_button, choice).matches?(page)
        end
      end
    end

    describe 'Entering a zipcode' do
      shared_examples "a failed zipcode entry" do
        before do

          populate_form_field(:user, :zipcode, zipcode)
          click_button('submit')

        end
        it 'should be on the start page' do
          expect(page).to display_account_finder_content(:start)
        end
        it 'should display the zipcode form' do
          expect(current_path).to eq(account_finder_start_path), 'should go back to zip entry'
        end
        it 'should fail validation and show an error' do
          expect(page).to display_error_message(expected_error)
        end
      end

      shared_examples 'a successful zipcode entry' do
        before do
          populate_form_field(:user, :zipcode, zipcode)
          click_button('submit')
        end
        it 'should pass validation' do
          expect(page).not_to display_any_errors
        end
        it 'should display the next question' do
          expect(page).to display_account_finder_content(:is_delinquent)
        end
      end



      describe 'with valid 5 digit code' do
        it_behaves_like 'a successful zipcode entry' do
          let(:zipcode) {good_zipcode}
        end
      end
      describe 'with valid 9 digit code' do
        it_behaves_like 'a successful zipcode entry' do
          let(:zipcode) {'11205-4407'}
        end
      end
      describe 'with valid zipcode format but foreign zip' do
        it_behaves_like 'a failed zipcode entry' do
          let(:expected_error) {I18n.t('errors.messages.zipcode_wrong_country')}
          let(:zipcode) {'34000'}
        end
      end
      describe 'with valid zipcode format but non existant zip' do
        it_behaves_like 'a failed zipcode entry' do
          let(:expected_error) {I18n.t('errors.messages.zipcode_not_found')}
          let(:zipcode) {'00000'}
        end
      end
      describe 'with invalid zipcode format' do
        it_behaves_like 'a failed zipcode entry' do
          let(:expected_error) {I18n.t('errors.messages.invalid_zipcode_format')}
          let(:zipcode) {nil}
        end
      end


    end



  end

end