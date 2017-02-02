class AddRecipientIdToBankAccount < ActiveRecord::Migration
  def change
    add_column :spree_bank_account, :recipient_id, :integer
    remove_column :spree_pagarme_recipients, :bank_account_id
  end
end
