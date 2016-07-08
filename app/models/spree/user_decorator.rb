# coding: utf-8
Spree::User.class_eval do

	has_many :pagarme_recipients, dependent: :destroy

end