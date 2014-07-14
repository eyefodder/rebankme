
include PageContentSteps
include AdminSteps
include DataEntrySteps




describe 'Bank Pages', :type => :request do
  let (:required_properties) {[:name]}
  subject {page}

  describe 'admin only: ' do
    describe 'index' do
      include_context 'is an admin only page' do
        let(:path_to_test){banks_path}
      end
    end
    describe 'new' do
      include_context 'is an admin only page' do
        let(:path_to_test){new_bank_path}
      end
    end
    describe 'edit' do
      include_context 'is an admin only page' do
        let(:path_to_test){new_bank_path}
      end
    end
  end

  describe 'index' do
    let!(:bank_0) {create(:bank)}
    let!(:bank_1) {create(:bank)}
    let!(:bank_2) {create(:bank)}
    let(:banks) {[bank_0, bank_1, bank_2]}
    before do

      as_admin
      visit banks_path
    end
    it 'shows all the bank names' do
      banks.each do |bank|
        expect(page).to have_css('span.editable-object-name', text: bank.name)
      end
    end
    it 'has delete link for each item' do
      banks.each do |bank|
        expect(page).to have_delete_bank_link(bank)
      end
    end
    it 'has edit link for each item' do
      banks.each do |bank|
        expect(page).to have_edit_bank_link(bank)
      end

    end
    describe 'clicking the delete button' do
      it 'reduces the number of users in the DB' do
        expect{click_link("delete_bank_#{bank_0.id}")}.to change{Bank.count}.by(-1)
      end
    end
  end


  def have_edit_bank_link(bank)
    have_link("edit_bank_#{bank.id}", edit_bank_path(bank))
  end

  def have_delete_bank_link(bank)
    have_xpath(".//a[@href='#{bank_path(bank)}' and @data-method='delete' and @class='action_delete' and @id='delete_bank_#{bank.id}' ]")
  end

  describe 'new' do
    before do
      as_admin
      visit new_bank_path
    end
    it_behaves_like 'a page that creates a new item with valid information', Bank do
      let(:post_create_path){banks_path}
    end
    it_behaves_like "a page that doesn't create with invalid information", Bank
  end

  describe 'edit' do
    let!(:item){create(:bank)}
    before do
      as_admin
      visit edit_bank_path(item)
    end
    it_behaves_like 'a page that updates item with valid information'
    it_behaves_like 'a page that errors with invalid information'
  end

end
