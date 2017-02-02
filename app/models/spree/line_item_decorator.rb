# coding: utf-8
Spree::LineItem.class_eval do

    def self.prioritize_for_split
        # order(:price)
    end

	def split_rule
        # TODO: para usar o Split, personalize esse método para retornar um objeto (siga o modelo abaixo:)
        # return {
        #     :recipient => Spree::PagarmeRecipient.master_recipient,
        #     :value => product.price
        # }

        return nil
    end

end