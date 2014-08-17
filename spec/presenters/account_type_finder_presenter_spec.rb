# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'

describe AccountTypeFinderPresenter do
  let(:user) { build(:user) }
  let(:presenter) { AccountTypeFinderPresenter.new(user, view) }
  let(:token) { UserPropertyQuestionFactory.next_property_for(user) }

  describe '#start_over_button' do
    it 'returns a start over link' do
      result = presenter.start_over_button
      expect(result).to have_tag(:a,
                                 with: { href: account_finder_start_path },
                                 text: I18n.t('forms.actions.start_over'))
    end
    it 'returns a start over link with styling' do
      options = { class: 'btn btn-default btn-block' }
      expect(presenter.start_over_button options).to have_tag(:a, with: options)
    end
  end

  describe '#page_heading' do
    # let(:token){presenter.next_property_token}
    it 'returns title from localized file' do
      result = presenter.page_heading
      expect(result).to eq(I18n.t("account_finder.#{token}.title"))
    end
  end

  describe '#page_title' do
    # let(:token){presenter.next_property_token}
    it 'returns title from localized file' do
      result = presenter.page_title
      expect(result).to eq(I18n.t("account_finder.#{token}.title"))
    end
  end

  describe '#next_question_tag' do
    # let(:token){presenter.next_property_token}
    it 'returns a tag with from localized content' do
      content = view.simple_format(I18n.t("account_finder.#{token}.question"))
      expected = view.content_tag(:div, content)
      expect(presenter.next_question_tag).to eq(expected)
    end
    it 'adds options to the tag' do
      options = { class: 'someclass', id: 'someid' }
      content = view.simple_format(I18n.t("account_finder.#{token}.question"))
      expected = view.content_tag(:div, content, options)
      expect(presenter.next_question_tag(options)).to eq(expected)
    end
  end

  describe '#yes_button' do
    it 'returns default stuff' do
      result = presenter.yes_button
      expect(result).to have_tag(:button,
                                 text: expected_label_for(:yes),
                                 with: { name: "user[#{token}]",
                                         type: 'submit',
                                         value: true,
                                         id: 'next_question_yes' })
    end
    it 'allows you to pass html options' do
      options = { class: 'someclass' }
      expect(presenter.yes_button(options)).to have_tag(:button, with: options)
    end
  end

  describe '#no_button' do
    it 'returns default stuff' do
      result = presenter.no_button
      expect(result).to have_tag(:button,
                                 text: expected_label_for(:no),
                                 with: { name: "user[#{token}]",
                                         type: 'submit',
                                         value: false,
                                         id: 'next_question_no' })
    end
    it 'allows you to pass html options' do
      options = { class: 'someclass' }
      expect(presenter.no_button(options)).to have_tag(:button, with: options)
    end
  end

  def expected_label_for(action)
    prop = UserPropertyQuestionFactory.next_property_for(user)
    token = "account_finder.#{prop}.action_#{action}"
    default = I18n.t("forms.actions.action_#{action}")
    I18n.t(token, default: default)
  end

end
