# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class AdminController < ApplicationController
  before_action :authenticate_admin_user!

  def home
    @admin = current_admin_user
    @funnel = MetricsFunnel.new
    metric_names.each do |metric_name|
      metric = Vanity.playground.metric(metric_name)
      total_count = metric_total_count(metric)
      @funnel.add_metric(metric.name, metric.description, total_count)
    end
  end

  private

  def metric_total_count(metric)
    return 0 unless Vanity.playground.collecting?
    Vanity::Metric.data(metric).to_a.reduce(0) { |a, e| a + e[1] }
  end

  def metric_names
    [:shown_home_page,
     :shown_start_page,
     :started_account_type_finder,
     :shown_account_type,
     :shown_find_account,
     :shown_request_email,
     :shown_help_me_open]
  end
end
