# coding: utf-8
Spree::Product.class_eval do
  # attr_accessible :recipient_id

  belongs_to :spree_pagarme_recipients
   
end