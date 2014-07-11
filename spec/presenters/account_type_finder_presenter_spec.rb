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
      expected = view.content_tag(:div,expected_content , class: 'account-finder-question')
      expect(presenter.next_question_tag).to eq(expected)
    end
  end

  describe '#decision_buttons' do
    it 'returns tags for the yes and no buttons' do
      expected = view.content_tag(:button, I18n.t('forms.actions.action_yes'), class: 'btn btn-info', name: "user[#{token}]", type: 'submit', value: true)
      expected = expected + view.content_tag(:button, I18n.t('forms.actions.action_no'), class: 'btn btn-info', name: "user[#{token}]", type: 'submit', value: false)
      expect(presenter.decision_buttons).to eq(expected)

    end
  end


end