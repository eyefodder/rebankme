require 'spec_helper'

describe MetricsFunnelPresenter do
  let(:funnel) { MetricsFunnel.new }
  let(:presenter){MetricsFunnelPresenter.new(funnel, view)}


  describe '#metrics_table' do
    it 'returns nothing if no metrics' do
      expect(presenter.metrics_table).to be_nil
    end

    it 'returns a rendered partial if funnel has metrics' do
      funnel.add_metric('name', 'desc', 2)
      expected = view.render(partial: 'admin/metrics_table', locals: {presenter: presenter, funnel: funnel})
      expect(presenter.metrics_table).to eq expected
    end
  end

  describe '#metric_retention' do
    let!(:first) {funnel.add_metric('first', 'first', 10)}
    let!(:second) {funnel.add_metric('first', 'first', 8)}

    it 'gives -- for the first metric' do
      expect(presenter.metric_retention first).to eq('n/a')
    end

    it 'gives correct value for others' do
      expect(presenter.metric_retention second).to eq('80.0%')
    end
  end

  describe '#metric_as_prog_bar' do
    let!(:first) {funnel.add_metric('first', 'first', 10)}
    let!(:second) {funnel.add_metric('first', 'first', 8)}

    it 'creates a progress bar' do
      expected = view.content_tag(:div, class: 'progress') do
        view.content_tag(:div,
          first.count,
          class: 'progress-bar',
            role: 'progressbar',
            aria: {
              valuenow: first.count,
              valuemin: funnel.min_count,
              valuemax: funnel.max_count,
              },
              style: "width: #{first.pct_of_max}%; min-width: 20px;",
              )
      end
      expect(presenter.metric_as_prog_bar first).to eq(expected)
    end

  end



end