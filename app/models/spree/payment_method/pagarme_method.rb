module Spree
  class PaymentMethod::PagarmeMethod < PaymentMethod
    # attr_protected
    # attr_accessor :order_id

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
      # pagarme_payment = payment.pagarme_payment.present? ? payment.pagarme_payment : Spree::PagSeguroPayment.new(payment_id: payment.id)
      # pagarme_payment.process!(1) if pagarme_payment.transaction_id.nil?
      # pagarme_payment.transaction_id
    end

  end
end
