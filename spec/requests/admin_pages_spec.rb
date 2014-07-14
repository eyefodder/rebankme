
include PageContentSteps

describe 'Admin Pages', :type => :request do

  subject {page}

  before do
    visit admin_path
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
      expect(page).to show_signed_in_message
    end
    it 'displays admin navigation' do
      expect(page).to show_admin_nav
    end

    describe 'then logging out' do
      before do
        click_link('logout')
      end
      it 'displays a signout message' do
        expect(page).to show_signed_out_message
      end
      it 'is on root path' do
        expect(current_path).to eq root_path
      end
    end


  end

end

def show_admin_nav
  have_css('#admin-nav')
end

def show_signed_in_message
  have_flash_message(:notice => 'Signed in successfully.')
end

def show_signed_out_message
  have_flash_message(:notice => 'Signed out successfully.')
end

