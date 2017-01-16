class AddPagarmeIdToWithdrawalInfo < ActiveRecord::Migration
  def change
    add_column :spree_withdrawal_infos, :pagarme_id, :integer
  end
end
