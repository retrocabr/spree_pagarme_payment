class ChangeSpreeWithdrawalInfo < ActiveRecord::Migration
  def change
    rename_table :spree_withdrawal_infos, :spree_bank_account
  end
end
