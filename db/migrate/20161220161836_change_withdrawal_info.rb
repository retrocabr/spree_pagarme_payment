class ChangeWithdrawalInfo < ActiveRecord::Migration
  def change
    add_column :spree_withdrawal_infos, :user_id, :integer
    remove_column :spree_withdrawal_infos, :bag_id
  end
end
