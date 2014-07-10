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

    it 'has a link to start the account finding process' do
      expect(page).to have_link('start-account-finder', href: account_finder_start_path)
    end
	end



  #  def have_errors
  #   have_selector('div.alert.alert-error')
  # end
end