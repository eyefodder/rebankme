
require 'spec_helper'

describe MetricsFunnel do
  let(:funnel) {MetricsFunnel.new}

  describe '#has_metrics?' do
    it 'returns false if no metrics added' do
      expect(funnel.has_metrics?).to be_false
    end

    it 'returns true if metric added' do
      funnel.add_metric(:name, :description, 12)
      expect(funnel.has_metrics?).to be_true
    end

  end


  describe 'adding a metric' do
    it 'increases count by 1' do
      expect{funnel.add_metric(:name, :description, 12)}.to change{funnel.metrics.count}.by(1)
    end

    it 'has an index property' do
      funnel.add_metric(:name, :description, 12)
      expect(funnel.metrics.first.index).to eq 0
    end
  end

  describe 'minimum and maximum' do
    before do
      funnel.add_metric(:name, :description,2)
      funnel.add_metric(:name, :description,22)
      funnel.add_metric(:name, :description,3)
    end

    it 'min_count returns the smallest number in the funnel' do
      expect(funnel.min_count).to eq 2
    end
    it 'max_count returns the largest number in the funnel' do
      expect(funnel.max_count).to eq 22
    end
  end

end

describe FunnelMetric do
  let(:funnel) {MetricsFunnel.new}
  let!(:first) {funnel.add_metric(:name, :description,20)}
  let!(:second) {funnel.add_metric(:name, :description,50)}
  let!(:third) {funnel.add_metric(:name, :description,25)}



  it '#pct_of_max returns % of max number in funnel' do
    expect(first.pct_of_max).to eq (40.0)
    expect(second.pct_of_max).to eq (100.0)
    expect(third.pct_of_max).to eq (50.0)
  end

  it '#pct_retention returns nil for first number' do
    expect(first.pct_retention).to be_nil
  end

  it '#pct_retention returns > 100 for larger number than previous stage' do
    expect(second.pct_retention).to eq(250.0)
  end

  it '#pct_retention returns < 100 for larger number than previous stage' do
    expect(third.pct_retention).to eq(50.0)
  end



end