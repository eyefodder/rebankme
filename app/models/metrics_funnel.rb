class MetricsFunnel

  attr_accessor :metrics

  def initialize
    @metrics = []
  end

  def has_metrics?
    @metrics.length > 0
  end

  def add_metric(name, description, count)
    metric = FunnelMetric.new(name, description, count, @metrics.count, self)
    metrics << metric
    metric
  end

  def min_count
    min = metrics.min_by{ |x| x.count }
    min.count
  end

  def max_count
    max = metrics.max_by{ |x| x.count }
    max.count
  end

end

class FunnelMetric

  attr_accessor :name, :description, :count, :index, :funnel

  def initialize(name, description, count, index, funnel)
    @name = name
    @description = description
    @count = count
    @index = index
    @funnel = funnel
  end

  def pct_of_max
    100.0 * @count / @funnel.max_count
  end

  def pct_retention
    unless index==0
      prev = funnel.metrics[index-1]
      100.0 - (100.0 * (prev.count - @count) / prev.count)
    end
  end
end