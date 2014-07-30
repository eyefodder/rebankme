require 'spec_helper'

describe AccountTypeFinderPresenter do
  let(:user){build(:user)}
  let(:presenter){AccountTypeFinderPresenter.new(user,view)}
  let(:token){presenter.next_property_token}

  describe '#next_property_token' do
    it 'returns :is_delinquent first' do
      expect(presenter.next_property_token).to eq(:is_delinquent)
    end

    it 'returns :has_predictable_income if :is_delinquent is true' do
      user.is_delinquent = true
      expect(presenter.next_property_token).to eq(:has_predictable_income)
    end
    it 'returns :is_special_group if :is_delinquent is false' do
      user.is_delinquent = false
      expect(presenter.next_property_token).to eq(:is_special_group)
    end
    it 'returns :will_use_direct_deposit if :is_delinquent -> false and :is_special_group -> false' do
      user.is_delinquent = false
      user.is_special_group = false
      expect(presenter.next_property_token).to eq(:will_use_direct_deposit)
    end
    it 'returns :needs_debit_card if :is_delinquent, :is_special_group and :will_use_direct_deposit all false' do
      user.is_delinquent = false
      user.is_special_group = false
      user.will_use_direct_deposit = false
      expect(presenter.next_property_token).to eq(:needs_debit_card)
    end
  end

  describe '#start_over_button' do
    it 'returns a start over link' do
      # expected = view.link_to(I18n.t("forms.actions.start_over"), account_finder_start_path, class: 'btn btn-default btn-block')
      expect(presenter.start_over_button).to have_tag(:a, with:{href: account_finder_start_path}, text: I18n.t("forms.actions.start_over") )
    end
    it 'returns a start over link with styling' do
      options = {class: 'btn btn-default btn-block'}
      expect(presenter.start_over_button options).to have_tag(:a, with: options)
    end
  end

  describe '#page_heading' do
    let(:token){presenter.next_property_token}
    it 'returns title from localized file' do
      expect(presenter.page_heading).to eq(I18n.t("account_finder.#{token}.title"))
    end
  end

  describe '#page_title' do
    let(:token){presenter.next_property_token}
    it 'returns title from localized file' do
      expect(presenter.page_title).to eq(I18n.t("account_finder.#{token}.title"))
    end
  end

  describe '#next_question_tag' do
    let(:token){presenter.next_property_token}
    it 'returns a tag with from localized content' do
      expected_content = I18n.t("account_finder.#{token}.question")
      expected = view.content_tag(:div,expected_content)
      expect(presenter.next_question_tag).to eq(expected)
    end
    it 'adds options to the tag' do
      options = {class: 'someclass', id: 'someid'}
      expected_content = I18n.t("account_finder.#{token}.question")
      expected = view.content_tag(:div,expected_content , options)
      expect(presenter.next_question_tag(options)).to eq(expected)
    end
  end

  # describe '#decision_buttons' do


  #   it 'returns tags for the yes and no buttons' do

  #     yes_button  = view.content_tag(:button, expected_label_for(:yes), class: 'btn btn-info btn-block', name: "user[#{token}]", type: 'submit', value: true, id: 'next_question_yes')
  #     no_button = view.content_tag(:button, expected_label_for(:no), class: 'btn btn-info btn-block', name: "user[#{token}]", type: 'submit', value: false, id: 'next_question_no')
  #     expected = view.content_tag(:div, class: 'row') do
  #       # view.content_tag(:div, yes_button, class: 'col-xs-5') + view.content_tag(:div, no_button, class: 'col-xs-5 col-xs-offset-2')
  #       view.content_tag(:div, class: 'col-xs-12') do
  #         yes_button + no_button
  #       end
  #     end
  #     # expected = expected + view.content_tag(:button, I18n.t('forms.actions.action_no'), class: 'btn btn-info', name: "user[#{token}]", type: 'submit', value: false)
  #     expect(presenter.decision_buttons).to eq(expected)

  #   end


  # end

  describe '#yes_button' do
    it 'returns default stuff' do
      expect(presenter.yes_button).to have_tag(:button, text: expected_label_for(:yes), with:{ name: "user[#{token}]", type: 'submit', value: true, id: 'next_question_yes' })
    end
    it 'allows you to pass html options' do
      options = {class: 'someclass'}
      expect(presenter.yes_button(options)).to have_tag(:button, with: options)
    end
  end

  describe '#no_button' do
    it 'returns default stuff' do
      expect(presenter.no_button).to have_tag(:button, text: expected_label_for(:no), with:{ name: "user[#{token}]", type: 'submit', value: false, id: 'next_question_no' })
    end
    it 'allows you to pass html options' do
      options = {class: 'someclass'}
      expect(presenter.no_button(options)).to have_tag(:button, with: options)
    end
  end

  def expected_label_for(action)
    token = presenter.next_property_token
    I18n.t("account_finder.#{token}.action_#{action}", default: I18n.t("forms.actions.action_#{action}"))
  end


end