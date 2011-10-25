class AddSubscriptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscription, :integer, :default => 0
  end
end
