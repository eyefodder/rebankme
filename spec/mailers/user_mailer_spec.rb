# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'

describe UserMailer do
  describe '.notify_of_help_request' do
    let(:user) do
      create(:user,
             zipcode: '11205',
             is_delinquent: false,
             will_use_direct_deposit: true,
             has_predictable_income: false)
    end
    let(:account_type) { AccountType.SAFE_ACCOUNT }
    let(:result) { ActionMailer::Base.deliveries.last }

    before do
      ActionMailer::Base.deliveries.clear
      UserMailer.notify_of_help_request(user.id, account_type.id).deliver
    end

    it 'sends email' do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
    it "sends mail to ENV['MAILER_REBANK_RECIPIENT']" do
      expected = ENV['MAILER_REBANK_RECIPIENT'] || 'test@example.com'
      expect(result.to).to include expected
    end
    it "cc's the mailer" do
      expected = ActionMailer::Base.smtp_settings[:user_name]
      expect(result.cc).to include expected
    end
    it 'has a subject line based on account type and user email' do
      expected = "#{account_type.name} help request from #{user.email}"
      expect(result.subject).to eq expected
    end
    it 'displays the account type' do
      expected = 'This is the account type ' \
                 "they asked about: #{account_type.name}"
      expect(result.body).to have_content(expected)
    end

    it 'displays the user properties' do
      properties = [:email,
                    :zipcode,
                    :is_delinquent,
                    :special_group?,
                    :will_use_direct_deposit,
                    :has_predictable_income,
                    :needs_debit_card]
      properties.each do |property|
        value = user[property]
        label = property.to_s.humanize
        expect(result.body).to have_content("#{label}: #{value}")
      end
    end

    it "displays the user's State" do
      expect(result.body).to have_content('State: New York')
    end

    describe ' with special group user' do

      before do
        user.special_group = SpecialGroup.VETERAN
        user.save!
        UserMailer.notify_of_help_request(user.id, account_type.id).deliver
      end

      it 'displays the name of the type of special group' do
        expected = "Special group: #{SpecialGroup.VETERAN.name_id}"
        expect(result.body).to have_content(expected)
      end

    end
  end
end
