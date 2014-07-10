
include PageContentSteps
describe 'Account Finder Pages', :type => :request do

  subject {page}

  describe 'Start' do
    before do
      visit account_finder_start_path
    end
    describe 'page content' do
      it 'has page title' do
        expect(page).to have_page_title(I18n.t('account_finder.start.title'))
      end
      it 'has page heading' do
        expect(page).to have_page_heading(I18n.t('account_finder.start.title'))
      end
      it 'has a zipcode entry form' do
        expect(page).to have_form_for(:user).with_field(:zipcode)
      end
    end




    describe 'Entering a zipcode' do
      shared_examples "a failed zipcode entry" do
       it 'should display the zipcode form' do
        expect(current_path).to eq(account_finder_start_path), 'should go back to zip entry'
      end
      it 'should fail validation and show an error' do
        expect(page).to display_error_message(expected_error)
      end

    end



    describe 'with valid 5 digit code' do
      before do
        fill_in('zipcode', with: '11205')
      end
      it 'should pass validation'
      it 'should display the next question'
    end
    describe 'with valid 9 digit code' do
      before do
        fill_in('zipcode', with: '11205-4407')
      end
      it 'should pass validation'
      it 'should display the next question'
    end
    describe 'with valid zipcode format but foreign zip' do
      before do
        populate_form_field(:user, :zipcode, '34000')
        click_button('submit')
      end
      it_behaves_like 'a failed zipcode entry' do
        let(:expected_error) {I18n.t('errors.messages.zipcode_wrong_country')}
      end
    end
    describe 'with valid zipcode format but non existant zip' do
      before do
        populate_form_field(:user, :zipcode, '00000')
        click_button('submit')
      end
      it_behaves_like 'a failed zipcode entry' do
        let(:expected_error) {I18n.t('errors.messages.zipcode_not_found')}
      end
    end
    describe 'with invalid zipcode format' do
      before do
        populate_form_field(:user, :zipcode, 'wwqq2')
        click_button('submit')
      end
       it_behaves_like 'a failed zipcode entry' do
        let(:expected_error) {I18n.t('errors.messages.invalid_zipcode_format')}
      end
    end
    describe 'with blank zipcode' do
      before do
        click_button('submit')
      end
      it_behaves_like 'a failed zipcode entry' do
        let(:expected_error) {"Zipcode can't be blank"}
      end
    end

  end



end

end