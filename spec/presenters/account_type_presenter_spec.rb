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

  def expected_title(name_id)
    product_name = I18n.t("#{account_type.name_id}.name")
    I18n.t("account_finder.account_type_found.title", product: product_name)
  end

end