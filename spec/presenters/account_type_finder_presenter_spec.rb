require 'spec_helper'

describe AccountTypeFinderPresenter do
  let(:user){build(:user)}
  let(:presenter){AccountTypeFinderPresenter.new(user,view)}
  let(:token){UserPropertyQuestionFactory.next_property_for(user)}

  describe '#question_specific_form_content' do
    it 'returns nothing if no special template' do
      expect(presenter.question_specific_form_content).to be_nil
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
    # let(:token){presenter.next_property_token}
    it 'returns title from localized file' do
      expect(presenter.page_heading).to eq(I18n.t("account_finder.#{token}.title"))
    end
  end

  describe '#page_title' do
    # let(:token){presenter.next_property_token}
    it 'returns title from localized file' do
      expect(presenter.page_title).to eq(I18n.t("account_finder.#{token}.title"))
    end
  end

  describe '#next_question_tag' do
    # let(:token){presenter.next_property_token}
    it 'returns a tag with from localized content' do
      expected_content = view.simple_format(I18n.t("account_finder.#{token}.question"))
      expected = view.content_tag(:div,expected_content)
      expect(presenter.next_question_tag).to eq(expected)
    end
    it 'adds options to the tag' do
      options = {class: 'someclass', id: 'someid'}
      expected_content = view.simple_format(I18n.t("account_finder.#{token}.question"))
      expected = view.content_tag(:div,expected_content , options)
      expect(presenter.next_question_tag(options)).to eq(expected)
    end
  end



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
    token = UserPropertyQuestionFactory.next_property_for(user)
    I18n.t("account_finder.#{token}.action_#{action}", default: I18n.t("forms.actions.action_#{action}"))
  end


end