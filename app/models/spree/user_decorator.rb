# coding: utf-8
Spree::User.class_eval do

	has_one :pagarme_recipient, dependent: :destroy
    has_many :bank_accounts, dependent: :destroy

end