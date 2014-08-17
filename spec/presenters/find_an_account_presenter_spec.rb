# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'

describe FindAnAccountPresenter do
  let(:user) { create(:user) }
  let(:account_type) { AccountType.SAFE_ACCOUNT }
  let(:presenter) { FindAnAccountPresenter.new(account_type, view) }
  let(:token_branching_element) { '' }
  let(:bank_account) { create(:bank_account) }

  before do
    presenter.user = user
  end

  RSpec::Matchers.define :return_localized_content do |token, tag, inter_args|
    chain :with_options do |options|
      @options = options
    end
    match do |returned|
      args = { default: '' }.merge(inter_args)
      content = I18n.t(token, args)
      if content == ''
        returned.nil?
      else
        return_wrapped_content(content, tag).matches?(returned)
      end
    end
  end

  RSpec::Matchers.define :return_wrapped_content do |content, tag|
    chain :with_options do |options|
      @options = options
    end
    match do |returned|
      if @options
        have_tag(tag, text: content,  with: @options).matches?(returned)
      else
        have_tag(tag, text: content).matches?(returned)
      end
    end
  end

  shared_examples 'a localized content wrapping method' do
    let(:token) do
      "account_finder.account_type.#{account_type.name_id}." \
      "#{token_branching_element}#{property}"
    end
    let(:tag) { :h3 }
    let(:args) { {} }

    it 'that passes options to the node' do
      options = { class: 'someclass', id: 'someid' }
      result = presenter.send(property, options)
      expect(result).to return_localized_content(token,
                                                 tag,
                                                 args).with_options(options)
    end

  end

  shared_examples 'a content wrapping method' do
    let(:options) { { class: 'someclass', id: 'someid' } }
    it 'that passes options to the node' do
      result = presenter.send(method, options)
      expect(result).to return_wrapped_content(expected,
                                               tag).with_options(options)
    end
  end

  shared_examples 'a google map block' do

    it 'with specified query' do
      src = URI.encode("https://www.google.com/maps/embed/v1/#{api_method}" \
                       "?key=#{ApiKeys.google_maps}&q=#{query}")
      expected = view.render(partial: 'account_finder/account_type/google_map',
                             locals: { src: src })
      expect(presenter.send(method)).to eq(expected)

    end

  end

  describe 'localized content strings' do
    def expect_to_return_localized_string(presenter, property)
      result = presenter.send(property)
      expected = I18n.t('account_finder.account_type.' \
                        "#{account_type.name_id}.#{property}")
      expect(result).to eq(expected)
    end

    describe '#sub_heading' do
      it 'returns localized value' do
        expect_to_return_localized_string(presenter, :sub_heading)
      end
    end

    describe '#heading' do
      it 'returns localized value' do
        expect_to_return_localized_string(presenter, :heading)
      end
    end
    describe '#page_title' do
      it 'returns localized value' do
        expect_to_return_localized_string(presenter, :page_title)
      end
    end
  end

  describe 'branched content' do

    describe 'VETERANS ACCOUNT' do
      let(:account_type) { AccountType.VETERANS_ACCOUNT }
      describe 'chase state' do
        before do
          user.state =  State.find_by(code: 'NY')
          user.save!(validate: false)
        end
        it_behaves_like 'a localized content wrapping method' do
          let(:token_branching_element) { 'chase_states.' }
          let(:property) { :intro_heading }
        end

        it_behaves_like 'a google map block' do
          let(:query) { "Chase Branches near #{user.zipcode}" }
          let(:api_method) { :search }
          let(:method) { :google_map_search }
        end
      end
      describe 'non chase state' do
        before do
          user.state =  State.find_by(code: 'AL')
          user.save!(validate: false)
        end
        it_behaves_like 'a localized content wrapping method' do
          let(:token_branching_element) { 'non_chase_states.' }
          let(:property) { :intro_heading }
        end
        it 'returns nil for map search' do
          expect(presenter.google_map_search).to be_nil
        end
      end
    end

    describe 'SENIORS_ACCOUNT' do
      let(:account_type) { AccountType.SENIORS_ACCOUNT }
      describe 'U.S. Bank States' do
        before do
          user.state =  State.find_by(code: 'ID')
          user.save!(validate: false)
        end
        it_behaves_like 'a localized content wrapping method' do
          let(:token_branching_element) { 'us_bank_states.' }
          let(:property) { :intro_heading }
        end

        it_behaves_like 'a google map block' do
          let(:query) { "USBank Branches near #{user.zipcode}" }
          let(:api_method) { :search }
          let(:method) { :google_map_search }
        end

      end
      describe 'Non U.S. Bank States' do
        before do
          user.state =  State.find_by(code: 'NY')
          user.save!(validate: false)
        end
        it_behaves_like 'a localized content wrapping method' do
          let(:token_branching_element) { 'non_us_bank_states.' }
          let(:property) { :intro_heading }
        end
        it_behaves_like 'a google map block' do
          let(:query) { "Credit Unions near #{user.zipcode}" }
          let(:api_method) { :search }
          let(:method) { :google_map_search }
        end
      end
    end
  end

  describe 'content blocks' do
    describe '#intro_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :intro_heading }
      end
    end
    describe '#intro' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :intro }
        let(:tag) { :div }
      end
    end
    describe '#we_recommend_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :we_recommend_heading }
        let(:tag) { :div }
      end
    end

    describe '#why_chosen_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :why_chosen_heading }
      end
    end
    describe '#why_chosen_description' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :why_chosen_description }
        let(:tag) { :div }
        let(:args) { { zipcode: user.zipcode } }
      end
    end
    describe '#geolocated_results_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :geolocated_results_heading }
        let(:args) { { zipcode: user.zipcode } }
        let(:tag) { :h4 }
      end
    end
    describe '#geolocated_results_subheading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :geolocated_results_subheading }
        let(:args) { { zipcode: user.zipcode, num_results: 0 } }
        let(:tag) { :div }
      end
    end

  end

  describe '#recommended_option_block' do
    it 'returns nil if no recommended option' do
      expect(presenter.recommended_option_block).to be_nil
    end
    describe 'with recommended option' do
      before do
        presenter.recommended_option = bank_account
      end
      it 'renders a block' do
        partial = 'account_finder/account_type/recommended_option'
        expected = view.render(partial: partial,
                               locals: { presenter: presenter })
        expect(presenter.recommended_option_block).to eq expected
      end
    end
  end

  describe 'recommended_' do
    before do
      presenter.recommended_option = bank_account
    end
    describe '#recommended_account_name' do
      it_behaves_like 'a content wrapping method' do
        let(:method) { :recommended_account_name }
        let(:expected) { bank_account.name }
        let(:tag) { :h4 }
      end
    end
    describe '#recommended_branch_address' do
      it_behaves_like 'a content wrapping method' do
        let(:method) { :recommended_branch_address }
        let(:expected) { bank_account.branch.full_address }
        let(:tag) { :div }
      end
    end

    describe '#recommended_branch_name' do
      it_behaves_like 'a content wrapping method' do
        let(:method) { :recommended_branch_name }
        let(:expected) { bank_account.branch.full_name }
        let(:tag) { :div }
      end
    end

    describe '#recommended_available_at' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :recommended_available_at }
        let(:args) { { zipcode: user.zipcode, num_results: 0 } }
        let(:tag) { :div }
      end
    end
  end

  describe '#cta' do
    it 'returns a link to help me open page' do
      text = I18n.t('account_finder.account_type.help_to_open_cta')
      path = account_opening_assistance_path(user, account_type)
      expect(presenter.cta_button).to have_tag(:a,
                                               text: text,
                                               with: { href: path })
    end
  end

  describe 'selected_result' do
    before do
      presenter.selected_result = bank_account
    end
    describe '#option_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :option_heading }
        let(:args) { { branch_name: bank_account.branch.full_name } }
        let(:tag) { :h3 }
      end
    end
    describe '#option_subheading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) { :option_subheading }
        let(:args) { { branch_address: bank_account.branch.full_address } }
        let(:tag) { :div }
      end
    end

    describe '#geolocated_choice_map' do
      describe 'when no selected choice' do
        before do
          presenter.selected_result = nil
        end
        it 'returns nil' do
          expect(presenter.geolocated_choice_map).to be_nil
        end
      end

      it_behaves_like 'a google map block' do
        let(:query) do
          "#{bank_account.branch.bank.name}+#{bank_account.branch.full_address}"
        end
        let(:api_method) { :place }
        let(:method) { :geolocated_choice_map }
      end

    end
  end

  describe 'results' do
    let(:bank_account_2) { create(:bank_account) }
    let(:results) { [bank_account, bank_account_2] }

    before do
      presenter.results = results
    end
    describe '#geolocated_options_block' do
      it 'returns rendered block' do
        partial = 'account_finder/account_type/geolocated_options'
        expected = view.render(partial: partial,
                               locals: { presenter: presenter })
        expect(presenter.geolocated_options_block).to eq expected
      end
      describe 'with no results' do
        before do
          presenter.results = nil
        end
        it 'returns nothing' do
          expect(presenter.geolocated_options_block).to be_nil
        end
      end
    end

    describe '#geolocated_option_title' do
      it 'returns branch name' do
        result = presenter.geolocated_option_title bank_account_2
        expected = bank_account_2.branch.full_name
        expect(result).to eq expected
      end
    end

    describe '#geolocated_option_street' do
      it 'returns branch street' do
        result = presenter.geolocated_option_street bank_account_2
        expect(result).to eq bank_account_2.branch.street
      end
    end

    describe '#geolocated_distance_from_user' do
      it 'returns span tag' do
        distance = user.distance_to(bank_account_2.branch)
        content = view.number_to_human(distance, units: :miles)
        expected = view.content_tag(:span, content)
        result = presenter.geolocated_distance_from_user(bank_account_2)
        expect(result).to eq expected
      end
    end

    describe '#geolocated_result_link' do
      it 'returns wrapped link' do
        src = account_finder_path(user, selected_account_id: bank_account_2.id)
        content = 'thing'
        expected = view.link_to(content,
                                src,
                                id: "select_account_#{bank_account_2.id}")
        result = presenter.geolocated_result_link(bank_account_2) do
          content
        end
        expect(result).to eq expected
      end
    end
  end

  describe 'online only methods' do
    let(:account_type) { AccountType.PREPAY_CARD }
    let(:presenter) { FindAnAccountPresenter.new(account_type, view) }

    describe 'online_options' do
      it 'makes an array from localized content' do
        token = 'account_finder.account_type.' \
                "#{account_type.name_id}.online_options"
        expected = I18n.t(token).to_a.map { |obj| obj[1] }
        expect(expected.empty?).to be_false
        expect(presenter.online_options).to eq expected
      end
    end

    describe '#online_option_feature_bullets' do
      let(:list_options) { { class: 'listclass' } }
      let(:bullet_options) { { class: 'bulletclass' } }
      let(:bullets) do
        { 0 => '$4.95 per month',
          1 => 'No overdraft fees',
          2 => 'Uses the VISA network' }
      end
      it 'returns list as rendered bullets' do
        result = presenter.online_option_feature_bullets(bullets,
                                                         list_options,
                                                         bullet_options)
        expect(result).to have_tag(:ul, with: list_options) do
          with_tag(:li, text: '$4.95 per month', with: bullet_options)
          with_tag(:li, text: 'No overdraft fees', with: bullet_options)
          with_tag(:li, text: 'Uses the VISA network', with: bullet_options)
        end
      end
    end
  end

  describe 'google_map_search' do

    describe 'credit union' do
      let(:account_type) { AccountType.CREDIT_UNION }
      it_behaves_like 'a google map block' do
        let(:query) { "Credit Unions near #{user.zipcode}" }
        let(:api_method) { :search }
        let(:method) { :google_map_search }
      end
    end

    describe 'regular accounts' do
      let(:account_type) { AccountType.REGULAR_ACCOUNT }
      it_behaves_like 'a google map block' do
        let(:query) { "Free Checking near #{user.zipcode}" }
        let(:api_method) { :search }
        let(:method) { :google_map_search }
      end
    end
    describe 'student accounts' do
      let(:account_type) { AccountType.STUDENT_ACCOUNT }
      it_behaves_like 'a google map block' do
        let(:query) { "Free Student Checking near #{user.zipcode}" }
        let(:api_method) { :search }
        let(:method) { :google_map_search }
      end
    end

  end

end
