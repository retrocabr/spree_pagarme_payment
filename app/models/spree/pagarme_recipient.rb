# coding: utf-8
require 'pagarme'

module Spree
	class PagarmeRecipient < ActiveRecord::Base
		self.table_name = "spree_pagarme_recipients"
		# attr_accessible :user_id, :pagarme_id, :recipient_type
		# RECIPIENT_TYPES = ["master", "splitter", "seller", "consigner", "marketplace"]
		validates :user_id, presence: true

		belongs_to :user
		has_many :products

		def get_recipient(params = nil)
			PagarMe.api_key = ENV['PAGARME_API_KEY']
			if self.pagarme_id
				PagarMe::Recipient.find(self.pagarme_id)
			else
				if params
					agencia = params[:agency].split('-')
					conta = params[:account].split('-')

					PagarMe::Recipient.create({
						:bank_account => {
							:bank_code => params[:bank],
							:agencia => agencia[0],
							:agencia_dv => agencia[1],
							:conta => conta[0],
							:conta_dv => conta[1],
							:legal_name => params[:name],
							:document_type => params[:document_type],
							:document_number => params[:document],
							:charge_transfer_fees => true
						},
						:transfer_enabled => false,
						:transfer_interval => params[:transfer][:interval],
						:transfer_day => params[:transfer][:day]
					})
				end
			end
		end



	end
end