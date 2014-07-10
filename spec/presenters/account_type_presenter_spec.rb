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

  def expected_title(name_id)
    product_name = I18n.t("#{account_type.name_id}.name")
    I18n.t("account_finder.account_type_found.title", product: product_name)
  end

end