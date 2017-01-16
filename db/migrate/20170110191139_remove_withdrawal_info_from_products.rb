class RemoveWithdrawalInfoFromProducts < ActiveRecord::Migration
  def change
    remove_column :spree_products, :recipient_id
  end
end
