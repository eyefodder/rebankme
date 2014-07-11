require 'spec_helper'

describe AccountTypePresenter do
  let(:account_type){build(:account_type, name_id: 'prepay_card')}
  let(:presenter){AccountTypePresenter.new(account_type,view)}


  describe '#page_heading' do
    it 'returns title from localized file' do
     expect(presenter.page_title).to eq(expected_title(account_type.name_id))
   end
 end

 describe '#page_title' do
  it 'returns title from localized file' do
    expect(presenter.page_title).to eq(expected_title(account_type.name_id))
  end
end

describe '#account_type_overview' do
  it 'gives the account type overview rendered as html' do

    expected_heading = I18n.t("account_finder.account_type_found.overview_heading")
    expected_content = I18n.t("#{account_type.name_id}.overview")
    expected = view.content_tag(:h3, expected_heading) + view.content_tag(:div, expected_content)
    expect(presenter.account_type_overview).to eq(expected)
  end
end

shared_examples 'explains why chosen' do
  it 'provides a list item for each explanation' do
    presenter = AccountTypePresenter.new(account_type, view)

    expected_heading = view.content_tag(:h3, I18n.t("account_finder.account_type_found.why_we_chose_heading"))
    expected_body = ""
    reasons.each do |reason|
      token = "deciding_factors.#{reason.values.first ? 'positive' : 'negative'}.#{reason.keys.first}"
      expected_body = expected_body + view.content_tag(:li, I18n.t(token))
    end
    expected = expected_heading + view.content_tag(:ul, expected_body.html_safe)
    expect(presenter.why_account_type_chosen_for user).to eq(expected)
  end
end

describe '#why_account_type_chosen' do
  describe 'with prepay_card' do
    it_behaves_like 'explains why chosen' do
      let(:account_type){AccountType.PREPAY_CARD}
      let(:user){build(:user)}
      let(:reasons){[{is_delinquent: false}, {has_predictable_income: false}]}
    end
  end
  describe 'with second_chance' do
    it_behaves_like 'explains why chosen' do
      let(:account_type){AccountType.SECOND_CHANCE}
      let(:user){build(:user)}
      let(:reasons){[{is_delinquent: false}, {has_predictable_income: true}, {in_new_york_city: false}]}
    end
  end
  describe 'with special account' do
    it_behaves_like 'explains why chosen' do
      let(:account_type){AccountType.SPECIAL_GROUP}
      let(:user){build(:user)}
      let(:reasons){[{is_delinquent: false}, {is_special_group: true}]}
    end
  end
  describe 'with regular account' do
    it_behaves_like 'explains why chosen' do
      let(:account_type){AccountType.REGULAR_ACCOUNT}
      let(:user){build(:user)}
      let(:reasons){[{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: true}]}
    end
  end
  describe 'with credit union' do
    describe 'and non NYC user' do
      it_behaves_like 'explains why chosen' do
        let(:account_type){AccountType.CREDIT_UNION}
        let(:user){build(:non_nyc_user)}
        let(:reasons){[{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: false}]}
      end
    end
    describe 'and  NYC user' do
      it_behaves_like 'explains why chosen' do
        let(:account_type){AccountType.CREDIT_UNION}
        let(:user){build(:nyc_user)}
        let(:reasons){[{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: true}, {needs_debit_card: true}]}
      end
    end
  end
  describe 'with safe account' do
    describe 'and delinquent user' do
      it_behaves_like 'explains why chosen' do
        let(:account_type){AccountType.SAFE_ACCOUNT}
        let(:user){build(:nyc_user, is_delinquent: true)}
        let(:reasons){[{is_delinquent: true}, {has_predictable_income: true}, {in_new_york_city: true}]}
      end
    end
    describe 'non delinquent user' do
      it_behaves_like 'explains why chosen' do
        let(:account_type){AccountType.SAFE_ACCOUNT}
        let(:user){build(:nyc_user, is_delinquent: false)}
        let(:reasons){[{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: true}, {needs_debit_card: false}]}
      end
    end
  end
end

def expected_title(name_id)
  product_name = I18n.t("#{account_type.name_id}.name")
  I18n.t("account_finder.account_type_found.title", product: product_name)
end

end