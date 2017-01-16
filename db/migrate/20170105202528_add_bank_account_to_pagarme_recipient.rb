class AddBankAccountToPagarmeRecipient < ActiveRecord::Migration
  def change
    add_column :spree_pagarme_recipients, :bank_account_id, :integer
  end
end
