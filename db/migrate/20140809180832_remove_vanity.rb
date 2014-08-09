class RemoveVanity < ActiveRecord::Migration
  def self.up
    drop_table :vanity_metrics
    drop_table :vanity_metric_values
    drop_table :vanity_experiments
    drop_table :vanity_conversions
    drop_table :vanity_participants
  end
end
