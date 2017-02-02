module Spree
  class PaymentMethod::PagarmeMethod < PaymentMethod
    preference :auto_split, :boolean, default: false
    # https://pagarme.zendesk.com/hc/pt-br/articles/204766729-Qual-%C3%A9-o-desconto-de-transfer%C3%AAncia-cobrado-
    preference :transfer_fee, :decimal, default: 3.67
    preference :use_boleto, :boolean, default: true
    preference :use_credit_cart, :boolean, default: true

    has_many :payments, :as => :source
  
    def actions
      %w{capture void}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end
    
    def payment_source_class
      self.class
    end

    def source_required?
      false
    end

    def code(payment)
      
    end

    def available_methods
      methods = []
      methods << "boleto" if preferred_use_boleto
      methods << "credit_card" if preferred_use_credit_cart
      return methods.join(",")
    end

  end
end
