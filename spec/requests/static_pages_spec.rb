# require 'spec_helper'

include PageContentSteps

describe 'Static Pages', :type => :request do

	subject {page}

	describe 'Home Page' do
		before do
			visit root_path
		end

		it 'has default page title' do
			expect(page).to have_page_title('')
		end
	end

  describe 'Entering a zipcode' do

    before do
      visit root_path
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
    describe 'with invalid zipcode' do
      before do
        fill_in('zipcode', with: '34000')
      end
      it 'should fail validation and show an error'
      it 'should display the zipcode form'
    end

  end

  #  def have_errors
  #   have_selector('div.alert.alert-error')
  # end
end