
include PageContentSteps
include AccountFinderSteps
describe 'Account Finder Pages', :type => :request do

  subject {page}




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

    describe 'entering a non NYC zipcode' do
      before do
        populate_form_field(:user, :zipcode, non_nyc_zipcode)
        click_button('submit')
      end
      describe '> is not delinquent > is not special group' do
        before do
          click_no_button #is not delinquent
          click_no_button #is not special
        end
        describe '> will not direct Deposit' do
          it_behaves_like 'a question page' do
            let(:question_token) {:will_use_direct_deposit}
            let(:no_destination){{account_type: :credit_union}}
            let(:yes_destination){{account_type: :regular_account}}
          end
        end
      end
      describe '> is delinquent' do
        before do
          click_yes_button
        end
        describe '> has predictable income ' do
          it_behaves_like 'a question page' do
            let(:question_token) {:has_predictable_income}
            let(:no_destination){{account_type: :prepay_card}}
            let(:yes_destination){{account_type: :second_chance}}
          end
        end
      end
    end

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
      describe 'YES: > Has predictable income' do
        before do
          click_yes_button
        end
        it_behaves_like 'a question page' do
          let(:question_token) {:has_predictable_income}
          let(:no_destination){{account_type: :prepay_card}}
          let(:yes_destination){{account_type: :safe_account}}
        end
      end
      describe 'NO: > Is Special Group' do
        before do
          click_no_button
        end
        it_behaves_like 'a question page' do
          let(:question_token) {:is_special_group}
          let(:no_destination){:will_use_direct_deposit}
          let(:yes_destination){{account_type: :special_group}}
        end

        describe 'NO: > Will Direct Deposit?' do
          before do
            click_no_button
          end
          it_behaves_like 'a question page' do
            let(:question_token) {:will_use_direct_deposit}
            let(:no_destination){:needs_debit_card}
            let(:yes_destination){{account_type: :regular_account}}
          end
          describe 'NO: > Needs Debit Card?' do
            before do
              click_no_button
            end
            it_behaves_like 'a question page' do
              let(:question_token) {:needs_debit_card}
              let(:no_destination){{account_type: :safe_account}}
              let(:yes_destination){{account_type: :credit_union}}
            end
          end
        end
      end
    end






    describe 'Entering a zipcode' do
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