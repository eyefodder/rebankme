require "spec_helper"

describe UserMailer do
  describe '.notify_of_user_help_request' do
    let(:user) {create(:user, zipcode: '11205', is_delinquent: false, will_use_direct_deposit: true, has_predictable_income: false)}
    let(:account_type){AccountType.SAFE_ACCOUNT}
    let(:result){ActionMailer::Base.deliveries.last}


    before do
      ActionMailer::Base.deliveries.clear
      UserMailer.notify_of_user_help_request(user.id, account_type.id).deliver
    end



    it 'sends email' do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
    it "sends mail to ENV['MAILER_REBANK_RECIPIENT']" do
      expect(result.to).to include ENV['MAILER_REBANK_RECIPIENT']
    end
    it "cc's the mailer" do
      expect(result.cc).to include ActionMailer::Base.smtp_settings[:user_name]
    end
    it "has a subject line based on account type and user email" do
      expect(result.subject).to eq "#{account_type.name} help request from #{user.email}"
    end
    it "displays the account type" do
      expect(result.body).to have_content("This is the account type they asked about: #{account_type.name}")
    end



    it 'displays the user properties' do
      [:email,
        :zipcode,
        :is_delinquent,
        :is_special_group,
        :will_use_direct_deposit,
        :has_predictable_income,
        :needs_debit_card].each do |property|
          value = user[property]
          label = property.to_s.humanize
          # expected =
          expect(result.body).to have_content("#{label}: #{value}")
        end
    end

    it "displays the user's State" do
      expect(result.body).to have_content("State: New York")
    end

    describe ' with special group user' do

      before do
        user.special_group = SpecialGroup.VETERAN
        user.save!
        UserMailer.notify_of_user_help_request(user.id, account_type.id).deliver
      end

      it 'displays the name of the type of special group' do
        expected = "Special group: #{SpecialGroup.VETERAN.name_id}"
        expect(result.body).to have_content(expected)
      end

    end


    end
  end
