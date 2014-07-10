
include PageContentSteps
describe 'Account Finder Pages', :type => :request do

  subject {page}

  shared_examples 'a question page' do
    it 'has expected content' do
      expect(page).to display_account_finder_content(question_token)
    end
    it 'has correct question' do
      expect(page).to display_account_finder_question(question_token)
    end
    it 'has yes / no buttons' do
      expect(page).to display_choice_buttons([I18n.t('forms.actions.action_yes'), I18n.t('forms.actions.action_no')])
    end
    it 'goes to the right place on clicking yes' do
      click_yes_button
      it_should_be_at_right_destination(yes_destination)
    end
    it 'goes to the right place on clicking no' do
      click_no_button
      it_should_be_at_right_destination(no_destination)
    end

  end


  describe 'Start' do
    let(:good_zipcode) {'11205'}
    let(:non_nyc_zipcode) {'90210'}
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

    # describe 'entering a non NYC zipcode' do
    #   before do
    #     populate_form_field(:user, :zipcode, non_nyc_zipcode)
    #     click_button('submit')
    #   end
    #   describe
    # end

    describe '> is user delinquent:' do
      before do
        populate_form_field(:user, :zipcode, good_zipcode)
        click_button('submit')
      end
      it_behaves_like 'a question page' do
        let(:question_token){:is_delinquent}
        let(:yes_destination){:has_predictable_income}
        let(:no_destination){:is_special_group}
      end
      describe '> Has predictable income' do
        let(:question_token) {:has_predictable_income}
        let(:no_destination){{account_type: :prepay_card}}
        let(:yes_destination){{account_type: :safe_account}}
        before do
          click_yes_button
        end
        it_behaves_like 'a question page' do
          let(:question_token) {:has_predictable_income}
          let(:no_destination){{account_type: :prepay_card}}
          let(:yes_destination){{account_type: :safe_account}}
        end
      end
    end

    def it_should_be_at_right_destination(destination_info)
      if destination_info.is_a?(Hash)
        expect(page).to display_account_type_found_content(destination_info[:account_type])
      else
        expect(page).to display_account_finder_content(destination_info)
      end
    end

    RSpec::Matchers.define :display_account_type_found_content do |account_type_id|
      match do |page|
        product_name = I18n.t("#{account_type_id}.name")
        expected_heading = I18n.t("account_finder.account_type_found.title", product: product_name)
        have_page_heading(expected_heading).matches?(page)
        have_page_title(expected_heading).matches?(page)
      end
    end
    def click_no_button
      click_form_button(:no)
    end
    def click_yes_button
      click_form_button(:yes)
    end
    def click_form_button(action)
     click_button(I18n.t("forms.actions.action_#{action}"))
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