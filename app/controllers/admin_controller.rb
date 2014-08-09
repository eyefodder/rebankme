class AdminController < ApplicationController

  before_action :authenticate_admin_user!

  def home
    @admin = current_admin_user
    metric_names = [:shown_home_page,
     :shown_start_page,
     :started_account_type_finder,
     :shown_account_type,
     :shown_find_account,
     :shown_request_email,
     :shown_help_me_open]

     @metrics = []
     unless Rails.env.test?
      metric_names.each do |metric_name|
        metric = Vanity.playground.metric(metric_name)
        total_count = Vanity::Metric.data(metric).to_a.inject(0){|sum, obj| sum + obj[1]}

        @metrics << {metric: metric, total: total_count}
      end
    end
  end


end
