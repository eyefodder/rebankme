plot_chart = (chart_id) ->
  data = $(chart_id).data('chart-data')
  options = $(chart_id).data('chart-options')
  $(chart_id).plot(data, options)

jQuery( window ).load ->
  plot_chart('#funnel-chart')