# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'

describe AccountTypePresenter do
  let(:account_type) { AccountType.PREPAY_CARD }
  let(:presenter) { AccountTypePresenter.new(account_type, view) }

  describe '#page_heading' do
    it 'returns title from localized file' do
      expect(presenter.page_heading).to eq(expected_value(:heading,
                                                          account_type.name_id))
    end
  end

  describe '#page_title' do
    it 'returns title from localized file' do
      expect(presenter.page_title).to eq(expected_value(:page_title,
                                                        account_type.name_id))
    end
  end

  def expected_value(token, name_id)
    product_name = I18n.t("#{name_id}.name")
    I18n.t("account_finder.account_type_found.#{token}", product: product_name)
  end

  shared_examples 'explains why chosen' do
    it 'provides a list item for each explanation' do
      presenter = AccountTypePresenter.new(account_type, view)
      result = presenter.why_account_type_chosen_for user
      expect(result).to have_tag(:ul)
      reasons.each do |reason|
        expect(result).to have_tag(:li, text: expected_reason(reason))
      end
      if defined? excluded_reasons
        excluded_reasons.each do |reason|
          expect(result).not_to have_tag(:li, text: expected_reason(reason))
        end
      end
    end

    it 'lets you pass in class info for the list and bullets' do
      list_options = { class: 'list-gdsdsroup' }
      bullet_options = { class: 'list-group-itesdsdm list-group-item-info' }
      presenter = AccountTypePresenter.new(account_type, view)
      result = presenter.why_account_type_chosen_for user,
                                                     list_options,
                                                     bullet_options
      expect(result).to have_tag(:ul, with: list_options)
      reasons.each do |reason|
        expect(result).to have_tag(:li,
                                   text: expected_reason(reason),
                                   with: bullet_options)
      end
    end
  end
  def expected_reason(reason)
    pos_neg = reason.values.first ? 'positive' : 'negative'
    token = "deciding_factors.#{pos_neg}.#{reason.keys.first}"
    I18n.t(token)
  end

  describe '#why_account_type_chosen' do
    describe 'with prepay_card' do
      it_behaves_like 'explains why chosen' do
        let(:account_type) { AccountType.PREPAY_CARD }
        let(:user) { build(:user) }
        let(:reasons) do
          [{ is_delinquent: true }, { has_predictable_income: false }]
        end
      end
    end
    describe 'with prepay_card (non nyc, delinquent, regular income) ' do
      it_behaves_like 'explains why chosen' do
        let(:account_type) { AccountType.PREPAY_CARD }
        let(:user) do
          build(:user,
                zipcode: '90210',
                is_delinquent: true,
                has_predictable_income: true)
        end
        let(:reasons) { [{ is_delinquent: true }] }
        let(:excluded_reasons) { [{ has_predictable_income: false }] }
      end
    end
    describe 'with second_chance' do
      it_behaves_like 'explains why chosen' do
        let(:account_type) { AccountType.SECOND_CHANCE }
        let(:user) { build(:user) }
        let(:reasons) do
          [{ is_delinquent: true },
           { has_predictable_income: true },
           { in_new_york_city: false }]
        end
      end
    end
    describe 'with special account' do
      it_behaves_like 'explains why chosen' do
        let(:account_type) { AccountType.STUDENT_ACCOUNT }
        let(:user) { build(:user) }
        let(:reasons) { [{ is_delinquent: false }, { is_special_group: true }] }
      end
    end
    describe 'with regular account' do
      it_behaves_like 'explains why chosen' do
        let(:account_type) { AccountType.REGULAR_ACCOUNT }
        let(:user) { build(:user) }
        let(:reasons) do
          [{ is_delinquent: false },
           { is_special_group: false },
           { will_use_direct_deposit: true }]
        end
      end
    end
    describe 'with credit union' do
      describe 'and non NYC user' do
        it_behaves_like 'explains why chosen' do
          let(:account_type) { AccountType.CREDIT_UNION }
          let(:user) { build(:non_nyc_user) }
          let(:reasons) do
            [{ is_delinquent: false },
             { is_special_group: false },
             { will_use_direct_deposit: false },
             { in_new_york_city: false }]
          end
        end
      end
      describe 'and  NYC user' do
        it_behaves_like 'explains why chosen' do
          let(:account_type) { AccountType.CREDIT_UNION }
          let(:user) { build(:nyc_user) }
          let(:reasons) do
            [{ is_delinquent: false },
             { is_special_group: false },
             { will_use_direct_deposit: false },
             { in_new_york_city: true },
             { needs_debit_card: true }]
          end
        end
      end
    end
    describe 'with safe account' do
      describe 'and delinquent user' do
        it_behaves_like 'explains why chosen' do
          let(:account_type) { AccountType.SAFE_ACCOUNT }
          let(:user) { build(:nyc_user, is_delinquent: true) }
          let(:reasons) do
            [{ is_delinquent: true },
             { has_predictable_income: true },
             { in_new_york_city: true }]
          end
        end
      end
      describe 'non delinquent user' do
        it_behaves_like 'explains why chosen' do
          let(:account_type) { AccountType.SAFE_ACCOUNT }
          let(:user) { build(:nyc_user, is_delinquent: false) }
          let(:reasons) do
            [{ is_delinquent: false },
             { is_special_group: false },
             { will_use_direct_deposit: false },
             { in_new_york_city: true },
             { needs_debit_card: false }]
          end
        end
      end
    end
  end

end
