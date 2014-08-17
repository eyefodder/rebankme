# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)

include PageContentSteps
include AdminSteps

describe 'Admin Pages', type: :request do

  subject { page }

  describe 'root admin page' do
    include_context 'is an admin only page' do
      let(:path_to_test) { admin_path }
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

    it 'has a link to bank accounts' do
      expect(page).to have_admin_link(bank_accounts_path)
    end

    it 'has a link to the email job queue' do
      expect(page).to have_admin_link(job_queue_path)
    end
    it 'has a link to the metrics page' do
      expect(page).to have_admin_link(vanity_path)
    end

    it 'has an edit profile link' do
      expect(page).to have_admin_link(edit_admin_user_registration_path)
    end
    it 'has a logout link' do
      expect(page).to have_admin_link(destroy_admin_user_session_path)
    end

  end

  describe 'metrics table' do
    before do
      as_admin
      visit admin_path
    end
    it 'has a metrics table' do
      expect(page).to have_css('table#site-metrics-table')
    end
    it 'has each metric in the table' do
      selector = 'table#site-metrics-table td.metric-name'
      name_cell_text =  page.all(selector).map(&:text)
      expected_metric_names = [:shown_home_page,
                               :shown_start_page,
                               :started_account_type_finder,
                               :shown_account_type,
                               :shown_find_account,
                               :shown_request_email,
                               :shown_help_me_open]
      expected_metric_names.each do |metric_id|
        name = Vanity.playground.metric(metric_id).name
        expect(name_cell_text).to include(name)
      end

    end

  end

end
