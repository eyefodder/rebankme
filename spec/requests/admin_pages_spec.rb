describe 'Admin Pages', :type => :request do

  subject {page}

  describe 'logging in' do
    before do
      visit admin_path
    end

    it 'requires users to login'
    describe 'successfully logging in' do
      it 'displays a welcome message'
      it 'displays admin navigation'
    end
  end

end