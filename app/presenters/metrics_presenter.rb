class MetricsPresenter < BasePresenter
  presents :metrics

  def metrics_table

    if metrics.length > 1

      h.content_tag(:table, class: 'table table-striped table-condensed') do
        head = h.content_tag(:thead) do
          h.content_tag(:tr) do
            h.content_tag(:th, "Stage") +
            h.content_tag(:th, "# people") +
            h.content_tag(:th, "% Of total") +
            h.content_tag(:th, "% Drop from last stage")
          end
        end
        body = h.content_tag(:tbody) do
          rows = ""
          total = metrics.first[:total]
          last = metrics.first[:total]
          metrics.each do |metric_obj|
            row = h.content_tag(:tr) do
              amt = metric_obj[:total].to_f
              pc_total = h.number_to_percentage((amt/total) * 100, precision: 1)
              pc_from_last = h.number_to_percentage((amt/last) * 100, precision: 1)
              last = amt
            # puts ("amt: #{amt}, total: #{total}")

            h.content_tag(:td, metric_obj[:metric].name) +
            h.content_tag(:td, h.number_to_human(amt, precision: 0)) +
            h.content_tag(:td, pc_total) +
            h.content_tag(:td, pc_from_last)
          end



          # rows << {label: metric_obj[:metric].name, data:metric_obj[:total] }
          rows << row

        end
        rows.html_safe
      end


      head + body
    end

  end



end

def funnel_chart
  options =
  {series:
    { funnel:
      {
        show: true,

        margin: { right: 0.15},
        label: {
          show: true,
          align: "center",
          threshold: 0.05,

          },
          highlight: {
            opacity: 0.2
          }
          },
          },
          grid: {
            hoverable: true,
            clickable: true
          }
        }

        data = []
        metrics.each do |metric_obj|
          data << {label: metric_obj[:metric].name, data:metric_obj[:total] }
        end


        h.content_tag(:div, "", id: 'funnel-chart', style: 'height:800px; width:800px', data: {chart_data: data, chart_options:options})
      end





      private


    end