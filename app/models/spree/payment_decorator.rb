Spree::Payment.class_eval do
	# attr_accessible :pagarme_payment_attributes
	has_one :pagarme_payment
	accepts_nested_attributes_for :pagarme_payment

	def get_new_state
		if pagarme_payment
			pagarme_payment.update_state
			update_state
		end
	end

	def update_state
		pp = pagarme_payment
		case pp.state
			when 'processing'
				started_processing if state != "processing"
			when 'authorized','paid'
				if state != "completed"
					complete
					Spree::OrderMailer.payment_confirmation_email(order).deliver
				end
			when 'refunded'
				complete if can_complete?
			when 'pending_refund'
				complete if can_complete?
			when 'waiting_payment'
				pend if can_pend?
			when 'refused'
				failure if can_failure?
				transaction = pp.transaction
				message =  "Pagamento (#{self.id}) do Pedido (#{order.number}) recusado. \n"
				message += "Reason: #{transaction.status_reason} \n" if transaction
				Spree::OrderMailer.pagseguro_error_notification("Pagar.me - Payment Refused", message).deliver
				Spree::OrderMailer.payment_refused_email(pp.payment.order).deliver if pp.payment && pp.payment.order
		end
	end

end
