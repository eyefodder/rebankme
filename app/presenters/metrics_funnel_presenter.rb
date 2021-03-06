# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class MetricsFunnelPresenter < BasePresenter
  presents :metrics_funnel

  def metrics_table
    return unless metrics_funnel.metrics?
    h.render(partial: 'admin/metrics_table',
             locals: { presenter: self, funnel: metrics_funnel })
  end

  def metric_as_prog_bar(funnel_metric)
    h.content_tag(:div, class: 'progress') do
      h.content_tag(:div,
                    funnel_metric.count,
                    progress_bar_options(funnel_metric)
                    )
    end
  end

  def metric_retention(funnel_metric)
    val = funnel_metric.pct_retention
    val.nil? ? 'n/a' : h.number_to_percentage(val, precision: 1)
  end

  def progress_bar_options(funnel_metric)
    { class: 'progress-bar',
      role: 'progressbar',
      aria: {
        valuenow: funnel_metric.count,
        valuemin: metrics_funnel.min_count,
        valuemax: metrics_funnel.max_count
      },
      style: "width: #{funnel_metric.pct_of_max}%; min-width: 20px;" }
  end
end
