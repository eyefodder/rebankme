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
end