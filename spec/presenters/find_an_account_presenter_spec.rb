require 'spec_helper'

describe FindAnAccountPresenter do
  let(:user){create(:user)}
  let(:account_type){AccountType.SAFE_ACCOUNT}
  let(:presenter){FindAnAccountPresenter.new(account_type, view)}
  let(:token_branching_element){''}
  let(:bank_account){create(:bank_account)}

  before do
    presenter.user = user
  end


  RSpec::Matchers.define :return_localized_content do |token, tag, interpolation_args|
    chain :with_options do |options|
      @options = options
    end
    match do |returned|
      args = {default: ''}.merge(interpolation_args)
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
    let(:token) {"account_finder.account_type.#{account_type.name_id}.#{token_branching_element}#{property}"}
    let(:tag) {:h3}
    let(:interpolation_args) {{}}

    it 'that passes options to the node' do
      options = {class: 'someclass', id: 'someid'}
      expect(presenter.send(property, options)).to return_localized_content(token, tag, interpolation_args).with_options(options)
    end

  end

  shared_examples 'a content wrapping method' do
    let(:options) { {class: 'someclass', id: 'someid'}}
    it 'that passes options to the node' do
      expect(presenter.send(method, options)).to return_wrapped_content(expected, tag).with_options(options)
    end
  end

  shared_examples 'a google map block' do
        let(:query) {"#{bank_account.branch.bank.name}+#{bank_account.branch.full_address}"}
        let(:api_method) {:place}
        let(:method){:geolocated_choice_map}
    it 'with specified query' do
      src = URI::encode("https://www.google.com/maps/embed/v1/#{api_method}?key=#{ApiKeys.google_maps}&q=#{query}")
      expected = view.render(partial: 'account_finder/account_type/google_map', locals: {src: src})
      expect(presenter.send(method)).to eq(expected)

    end

  end





  describe 'localized content strings' do
    def expect_to_return_localized_string(presenter, property)
      expect(presenter.send(property)).to eq(I18n.t("account_finder.account_type.#{account_type.name_id}.#{property}"))
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
      describe 'chase state' do
        before do
          user.state =  State.find_by(code: 'NY')
          user.save!(validate: false)
        end
        it_behaves_like 'a localized content wrapping method' do
          let(:token_branching_element) {"chase_states."}
          let(:account_type){AccountType.VETERANS_ACCOUNT}
          let(:property) {:intro_heading}
        end
      end
      describe 'non chase state' do
        before do
          user.state =  State.find_by(code: 'AL')
          user.save!(validate: false)
        end
        it_behaves_like 'a localized content wrapping method' do
          let(:token_branching_element) {"non_chase_states."}
          let(:account_type){AccountType.VETERANS_ACCOUNT}
          let(:property) {:intro_heading}
        end
      end
    end

    describe 'SENIORS_ACCOUNT' do
      describe 'U.S. Bank States' do
        before do
          user.state =  State.find_by(code: 'ID')
          user.save!(validate: false)
        end
        it_behaves_like 'a localized content wrapping method' do
          let(:account_type){AccountType.SENIORS_ACCOUNT}
          let(:token_branching_element) {"us_bank_states."}
          let(:property) {:intro_heading}
        end
      end
      describe 'Non U.S. Bank States' do
        before do
          user.state =  State.find_by(code: 'NY')
          user.save!(validate: false)
        end
        it_behaves_like 'a localized content wrapping method' do
          let(:account_type){AccountType.SENIORS_ACCOUNT}
          let(:token_branching_element) {"non_us_bank_states."}
          let(:property) {:intro_heading}
        end
      end
    end
  end

  describe 'content blocks' do
    describe '#intro_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:intro_heading}
      end
    end
    describe '#intro' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:intro}
        let(:tag) {:div}
      end
    end
    describe '#we_recommend_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:we_recommend_heading}
      end
    end

    describe '#why_chosen_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:why_chosen_heading}
      end
    end
    describe '#why_chosen_description' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:why_chosen_description}
        let(:tag) {:div}
        let(:interpolation_args) {{zipcode: user.zipcode}}
      end
    end
    describe '#geolocated_results_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:geolocated_results_heading}
        let(:interpolation_args) {{zipcode: user.zipcode}}
        let(:tag) {:h4}
      end
    end
    describe '#geolocated_results_subheading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:geolocated_results_subheading}
        let(:interpolation_args) {{zipcode: user.zipcode, num_results: 0}}
        let(:tag) {:div}
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
        expected = view.render(partial:'account_finder/account_type/recommended_option', locals:{presenter: presenter})
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
        let(:method) {:recommended_account_name}
        let(:expected) {bank_account.name}
        let(:tag) {:h4}
      end
    end
    describe '#recommended_branch_address' do
      it_behaves_like 'a content wrapping method' do
        let(:method) {:recommended_branch_address}
        let(:expected) {bank_account.branch.full_address}
        let(:tag) {:div}
      end
    end

    describe '#recommended_branch_name' do
      it_behaves_like 'a content wrapping method' do
        let(:method) {:recommended_branch_name}
        let(:expected) {bank_account.branch.full_name}
        let(:tag) {:div}
      end
    end

    describe '#recommended_available_at' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:recommended_available_at}
        let(:interpolation_args) {{zipcode: user.zipcode, num_results: 0}}
        let(:tag) {:div}
      end
    end
  end

  describe '#cta' do
    it 'returns a link to help me open page' do
      text = I18n.t('account_finder.account_type.help_to_open_cta')
      path = account_opening_assistance_path(user, account_type)
      expect(presenter.cta_button).to have_tag(:a, text: text, with: {href: path})
    end
  end

  describe 'selected_result' do
    before do
      presenter.selected_result = bank_account
    end
    describe '#option_heading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:option_heading}
        let(:interpolation_args) {{branch_name: bank_account.branch.full_name}}
        let(:tag) {:h3}
      end
    end
    describe '#option_subheading' do
      it_behaves_like 'a localized content wrapping method' do
        let(:property) {:option_subheading}
        let(:interpolation_args) {{branch_address: bank_account.branch.full_address}}
        let(:tag) {:div}
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
        let(:query) {"#{bank_account.branch.bank.name}+#{bank_account.branch.full_address}"}
        let(:api_method) {:place}
        let(:method){:geolocated_choice_map}
      end

    end
  end



end