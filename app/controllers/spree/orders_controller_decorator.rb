# coding: utf-8
Spree::OrdersController.class_eval do
	protect_from_forgery
	skip_before_filter :restriction_access

	def postback
		if valid_postback?
			PagarMe.api_key = ENV['PAGARME_API_KEY']

			order = Spree::Order.find_by_number(params[:order_id])

			error = false

			if order
				message = "Order found! \n"
				if order.state == "canceled"
					message += "Order is canceled! \n"
				end

				pagarme_payment = Spree::PagarmePayment.find_by_transaction_id(params[:id])

				unless pagarme_payment
					amount = params[:transaction][:amount].to_i/100.0
					payment = order.payments.create(amount: amount, payment_method_id: 2, state: "pending")
					pagarme_payment = Spree::PagarmePayment.create(payment_id: payment.id, payment_method: params[:transaction][:payment_method], transaction_id: params[:id], state: params[:old_status], installments: params[:transaction][:installments], boleto_url: params[:transaction][:boleto_url], boleto_barcode: params[:transaction][:boleto_barcode], postback: params[:transaction][:postback_url], charge_amount: amount)
				end
				if pagarme_payment && params[:object] == "transaction"
					if pagarme_payment.payment.order.id == order.id
						if pagarme_payment.state != params[:current_status]

							pagarme_payment.state = params[:current_status]
							pagarme_payment.save

							payment = pagarme_payment.payment
							payment.update_state

							pm_name = case pagarme_payment.payment_method
								when 'credit_card' then 'Cartão de Crédito'
								when 'boleto' then 'Boleto'
								else
									pagarme_payment.payment_method
							end

							order.updater.update_payment_total
							order.updater.update_payment_state
							order.updater.update_payment_total
							order.save

							# store_credit_payment = order.store_credit_amount - order.store_credit_discount
							# order.update_attribute(:store_credit_payment, store_credit_payment)

						else
							message += "IGNORED: Pagarme payment with transaction_id (#{params[:id]}) is already (#{params[:current_status]}) \n"
							error = true
						end
					else
						message += "ERROR: Orders aren't matching: pagar.me order is (#{pagarme_payment.payment.order.number}) and parameter order is (#{order.number}) \n"
						error = true
					end
				else
					message += "ERROR: Pagarme payment with transaction_id (#{params[:id]}) not found and couldn't create a new payment \n"
					error = true
				end
			else
				message = "Order with number(#{params[:order_id]}) not found! \n"
				error = true
			end

			if error
				message += "Parameters: #{params}"
				Spree::OrderMailer.pagarme_error_notification("Pagar.me Postback Error", message).deliver
			end

			render json: params
		else
			message = "Validation failed! \nParameters: #{params}"

			Spree::OrderMailer.pagarme_error_notification("Pagar.me Postback Error - Validation", message).deliver
			render_invalid_postback_response
		end
	end

	protected

	def valid_postback?
		raw_post  = request.raw_post
		signature = request.headers['HTTP_X_HUB_SIGNATURE']
		PagarMe::Postback.valid_request_signature?(raw_post, signature)
	end

	def render_invalid_postback_response
		render json: {error: 'invalid postback'}, status: 400
	end
end