class CreateSpreePagarmePayments < ActiveRecord::Migration
	def change
		create_table :spree_pagarme_payments do |t|
			t.integer :payment_id
			t.string  :payment_method
			t.integer :transaction_id
			t.string  :card_hash
			t.string  :state, :default => 'pending'
			t.integer :installments, :default => 0
			t.string  :boleto_url
			t.string  :boleto_barcode
			t.string  :postback
		end
	end
end