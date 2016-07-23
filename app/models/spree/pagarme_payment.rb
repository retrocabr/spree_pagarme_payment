# coding: utf-8
require 'pagarme'

module Spree
	class PagarmePayment < ActiveRecord::Base
		self.table_name = "spree_pagarme_payments"
		# attr_accessible :payment_id, :payment_method, :card_hash, :transaction_id, :state, :installments, :boleto_url, :boleto_barcode, :postback
		belongs_to :payment

		# validates :payment_id, presence: true

		# def recipients
		#		[]
		# end

		# def split_rules
		# 	self.recipients.collect do |recipient|
		# 		{ recipient_id: recipient, percentage: 100 }
		# 	end
		# end

		def transaction(create_if_nil = false)
			PagarMe.api_key = ENV['PAGARME_API_KEY']
			if self.transaction_id
				transaction = PagarMe::Transaction.find_by_id(self.transaction_id)
			elsif create_if_nil
				order = payment.order
				a = order.bill_address
				postback = self.postback
				# postback = "http://requestb.in/1hx7qum1"

				params = {
					:amount => (self.charge_amount * 100).to_i,
					:payment_method => self.payment_method,
					:postback_url => postback,
					:async => true,
					:customer => {
						:name => a.firstname + ' ' + a.lastname,
						:document_number => a.cpf,
						:email => order.email,
						:address => {
							:street => a.address1,
							:street_number => a.address_number,
							:complementary => a.address2,
							:neighborhood => a.address_district,
							:zipcode => a.zipcode
						},
						:phone => {
							:ddd => a.phone_ddd,
							:number => a.phone
						}
					},
					# :split_rules => [
					# 	{ recipient_id: ENV['RETROCA_RECIPIENT_ID'], percentage: 100 }
					# ],
					:metadata => {
						:order => order.number
					}
				}
				if self.payment_method == "credit_card"
					params[:card_hash] = self.card_hash
					params[:installments] = self.installments
				end
				transaction = PagarMe::Transaction.new(params)
			end

			transaction if transaction
		end

		def update_state
			transaction = self.transaction
			if transaction
				self.state = transaction.status
				self.boleto_url = transaction.boleto_url
				self.boleto_barcode = transaction.boleto_barcode
				self.save
			end
		end

		def boleto_expiration_date
			transaction = self.transaction
			if payment_method == "boleto" && transaction
				transaction.boleto_expiration_date.to_datetime
			end
		end

		def within_expiration_date?
			if boleto_expiration_date && (next_business_day(boleto_expiration_date) + 3.days) > Time.now
				true
			else
				false
			end
		end

		def process!(checkout = 0)
			PagarMe.api_key = ENV['PAGARME_API_KEY']

			order = payment.order

			transaction = self.transaction(true)
			transaction.charge

			self.transaction_id = transaction.id
			self.state = transaction.status
			self.boleto_url = transaction.boleto_url
			self.boleto_barcode = transaction.boleto_barcode
			self.save

			# order.payment_total = order.total
			# order.save

			payment.response_code = transaction.id
			payment.save

			payment.update_state

			if self.state
				ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
			else
				ActiveMerchant::Billing::Response.new(true, 'failure', {}, {})
			end
		end

		private

		def next_business_day(date)
			skip_weekends(date, 1)
		end

		def skip_weekends(date, inc)
			date += inc.day
			while (date.wday % 7 == 0) or (date.wday % 7 == 6) do
				date += inc.day
			end
			date
		end

	end
end
