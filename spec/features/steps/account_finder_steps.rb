# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
module AccountFinderSteps
  extend RSpec::Matchers::DSL
  extend ActionView::Helpers::TextHelper

  RSpec::Matchers.define :have_find_account_button do |page_ref|
    match do |page|
      product_name = I18n.t("#{page_ref}.name")
      expected_text = I18n.t('account_finder.account_type_found.cta', product: product_name)
      have_link(expected_text).matches?(page)
    end
  end

  RSpec::Matchers.define :display_account_finder_content do |page_ref|
    match do |page|
      expected_heading = I18n.t("account_finder.#{page_ref}.title")
      have_page_heading(expected_heading).matches?(page)
      have_page_title(expected_heading).matches?(page)
    end
  end
  RSpec::Matchers.define :display_account_finder_question do |page_ref|
    locale_content = I18n.t("account_finder.#{page_ref}.question")
    # content = simple_format(locale_content)
    failure_message_for_should do |_actual|
      "expected to find <div class='account-finder-question'> with content: \n#{locale_content}"
    end
    match do |page|
      node = page.find('div.account-finder-question')
      if node.nil?
        false
      else
        node.native.inner_html == simple_format(locale_content)
        # have_css('div.account-finder-question', text: content).matches?(page)
      end
    end
  end
  shared_examples 'a multi choice question page' do
    it 'has expected content' do
      expect(page).to display_account_finder_content(question_token)
    end
    it 'has correct question' do
      expect(page).to display_account_finder_question(question_token)
    end
    it 'has yes / no buttons' do
      yes_btn = I18n.t('forms.actions.action_yes')
      no_btn = I18n.t('forms.actions.action_no')
      expect(page).to display_choice_buttons([yes_btn, no_btn])
    end

    it 'has start over button' do
      expect(page).to have_link(I18n.t('forms.actions.start_over'))
    end
    xit 'goes to the right place on clicking yes' do
      click_yes_button
      it_should_be_at_right_destination(yes_destination)
    end
    it 'goes to the right place on clicking no' do
      click_no_button
      it_should_be_at_right_destination(no_destination)
    end
  end
  shared_examples 'a question page' do
    it 'has expected content' do
      expect(page).to display_account_finder_content(question_token)
    end
    it 'has correct question' do
      expect(page).to display_account_finder_question(question_token)
    end
    it 'has yes / no buttons' do
      yes_btn = I18n.t('forms.actions.action_yes')
      no_btn = I18n.t('forms.actions.action_no')
      expect(page).to display_choice_buttons([yes_btn, no_btn])
    end

    it 'has start over button' do
      expect(page).to have_link(I18n.t('forms.actions.start_over'))
    end
    it 'goes to the right place on clicking yes' do
      click_yes_button
      it_should_be_at_right_destination(yes_destination)
    end
    it 'goes to the right place on clicking no' do
      click_no_button
      it_should_be_at_right_destination(no_destination)
    end
  end

  def it_should_be_at_right_destination(info)
    if info.is_a?(Hash)
      expect(page).to display_account_type_found(info[:account_type])
    else
      expect(page).to display_account_finder_content(info)
    end
  end

  RSpec::Matchers.define :display_choice_buttons do |choices|
    failure_message_for_should do
      "expected to find a button labelled '#{choice}'"
    end
    match do |page|
      choices.each do |choice|
        have_selector(:link_or_button, choice).matches?(page)
      end
    end
  end

  RSpec::Matchers.define :display_account_type_found do |act_type_id|
    match do |page|
      product_name = I18n.t("#{act_type_id}.name")
      expected_heading = I18n.t('account_finder.account_type_found.heading',
                                product: product_name)
      expected_title = I18n.t('account_finder.account_type_found.page_title',
                              product: product_name)
      have_page_heading(expected_heading).matches?(page)
      have_page_title(expected_title).matches?(page)
    end
  end

  shared_examples 'a failed zipcode entry' do
    before do

      populate_form_field(:user, :zipcode, zipcode)
      click_submit_button

    end
    it 'should be on the start page' do
      expect(page).to display_account_finder_content(:start)
    end
    it 'should display the zipcode form' do
      failure_msg = 'should go back to zip entry'
      expect(current_path).to eq(account_finder_start_path), failure_msg
    end
    it 'should fail validation and show an error' do
      expect(page).to display_error_message(expected_error)
    end
  end

  shared_examples 'a successful zipcode entry' do
    before do
      populate_form_field(:user, :zipcode, zipcode)
      click_submit_button
    end
    it 'should pass validation' do
      expect(page).not_to display_any_errors
    end
    it 'should display the next question' do
      expect(page).to display_account_finder_content(:is_delinquent)
    end
  end
end
