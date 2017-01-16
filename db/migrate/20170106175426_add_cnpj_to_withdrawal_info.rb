class AddCnpjToWithdrawalInfo < ActiveRecord::Migration
  def change
    add_column :spree_bank_account, :cnpj, :string
    add_column :spree_bank_account, :charge_transfer_fees, :boolean, default: true
  end
end
