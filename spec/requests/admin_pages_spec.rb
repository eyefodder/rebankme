
include PageContentSteps
include AdminSteps



describe 'Admin Pages', :type => :request do

  subject {page}

  describe 'root admin page' do
    include_context 'is an admin only page' do
      let(:path_to_test){admin_path}
    end
  end

  describe 'admin nav' do
    before do
      as_admin
      visit admin_path
    end
    it 'has a link to admin home' do
      expect(page).to have_admin_link(admin_path)
    end
    it 'has a link to banks' do
      expect(page).to have_admin_link(banks_path)
    end
    it 'has a link to branches' do
      expect(page).to have_admin_link(branches_path)
    end
    it 'has an edit profile link' do
      expect(page).to have_admin_link(edit_admin_user_registration_path)
    end
    it 'has a logout link' do
      expect(page).to have_admin_link(destroy_admin_user_session_path)
    end

  end



end




