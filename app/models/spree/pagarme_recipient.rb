# coding: utf-8
require 'pagarme'

module Spree
  class PagarmeRecipient < Spree::Base
    self.table_name = "spree_pagarme_recipients"

    RECIPIENT_TYPES = ["master", "splitter", "seller", "consigner", "marketplace"]
    TRANSFER_INTERVALS = ["daily", "weekly", "monthly"]

    validates :user_id, presence: true

    belongs_to :user
    has_many :products
    belongs_to :bank_account

    after_update :update_recipient

    def get_recipient(transfer_enabled = true, transfer_interval = 'monthly', transfer_day = 30)
      PagarMe.api_key = ENV['PAGARME_API_KEY']
      if self.pagarme_id
        PagarMe::Recipient.find(self.pagarme_id)
      else
        if params && !bank_account.nil?
          recebedor = PagarMe::Recipient.create({
            :bank_account_id => bank_account.pagarme_id,
            :transfer_enabled => transfer_enabled,
            :transfer_interval => transfer_interval,
            :transfer_day => params[:transfer][:day]
          })

          self.update_column(:pagarme_id, recebedor.id)
        end
      end
    end

    def update_bank
      get_recipient
    end

  end
end