class MetricsPresenter < BasePresenter
  presents :metrics

  def metrics_new
    h.render(partial: 'admin/metrics_table', locals: { presenter: self}) if metrics.length > 0
  end

  def min_count
    metrics.min_by{ |x| x[:total] }
  end
  def max_count
    metrics.max_by{ |x| x[:total] }
  end

  def metric_total(metric_obj)
    h.number_to_human(metric_obj[:total], precision: 0)
  end
  def metric_pct_of_total(metric_obj)
    amt = metric_obj[:total].to_f
    total = metrics.first[:total]
    (amt/total) * 100
  end

  def metrics_prog_bar(metric_obj)
    amt = metric_obj[:total]
    h.content_tag(:div, class: 'progress') do
      h.content_tag(:div,
        amt,
        class: 'progress-bar',
          role: 'progressbar',
          aria: {
            valuenow: amt,
            valuemin: min_count,
            valuemax: max_count,
          },
          style: "width: #{metric_pct_of_total(metric_obj)}%; min-width: 20px;",
            )
    end
  end

  def metric_drop_from_last(metric_obj, counter)
    if counter ==0
      '--'
    else
      last = metrics[counter-1][:total]
      amt = metric_obj[:total].to_f
      h.number_to_percentage(((last-amt)/last) * 100, precision: 1)
    end
  end







  private


end