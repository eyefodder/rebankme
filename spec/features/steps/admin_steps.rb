module AdminSteps
  extend RSpec::Matchers::DSL

  shared_context 'is an admin only page' do
    subject {page}
    before do
      visit path_to_test
    end

    it 'require users to login' do
      expect(current_path).to eq(new_admin_user_session_path)
    end
    describe 'successfully logging in' do
      before do
        fill_in('admin_user_email', with: 'paul@significancelabs.org')
        fill_in('admin_user_password', with: 'changeme')
        click_button('Sign in')
      end
      it 'displays a welcome message' do
        expect(page).to have_flash_message(:notice => 'Signed in successfully.')
      end
      it 'displays admin navigation' do
        expect(page).to have_css('#admin-nav')
      end

      it 'is on path attempted to visit' do
        expect(current_path).to eq path_to_test
      end

      describe 'then logging out' do
        before do
          click_link('logout')
        end
        it 'displays a signout message' do
          expect(page).to have_flash_message(:notice => 'Signed out successfully.')
        end
        it 'is on root path' do
          expect(current_path).to eq root_path
        end
      end
    end
  end

  RSpec::Matchers.define :have_admin_link do |path|
    failure_message_for_should do |actual|
      "expected to find link to #{path} in admin nav"
    end
    match do |page|
      within('#admin-nav') do
        have_xpath(".//a[@href='#{path}']").matches?(page)
      end


    end
  end


  # def have_admin_link(path)
  #   within('#admin-nav') do
  #     have_xpath(".//a[@href='#{path}']")
  #   end
  # end




end