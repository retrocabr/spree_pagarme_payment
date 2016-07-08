require "spree_pagarme_payment/version"

module SpreePagarmePayment
	# Your code goes here...
	class Engine < Rails::Engine
		require 'pagarme'
		isolate_namespace Spree
		engine_name 'spree_pagarme_payment'

		initializer "spree.register.pagarme_method", after: "spree.register.payment_methods" do |app|
			app.config.spree.payment_methods << Spree::PaymentMethod::PagarmeMethod
		end

		config.autoload_paths += %W(#{config.root}/lib)

		# use rspec for tests
		config.generators do |g|
			g.test_framework :rspec
		end

		def self.activate
			Dir.glob(File.join(File.dirname(__FILE__), '../app/**/spree/*_decorator*.rb')) do |c|
				Rails.configuration.cache_classes ? require(c) : load(c)
			end
		end

		config.to_prepare &method(:activate).to_proc
	end
end