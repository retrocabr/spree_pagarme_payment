# SpreePagarmePayment

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spree_pagarme_payment'
```

And then execute:

    $ bundle install
    $ rails g spree_pagarme_payment:install

Or install it yourself as:

    $ gem install spree_pagarme_payment

## Usage

Set these environment variables:

```ruby
# Admin emails to receive error payment messages
ENV['ADMIN_EMAILS'] = "spree@example.com,spree@google.com"

# Pagarme keys
ENV[PAGARME_API_KEY]="YOUR_API_KEY_HERE"
ENV[PAGARME_CRYPTKEY]="YOUR_ENCRYPTION_KEY_HERE"
```

## Contributing

1. Fork it ( https://github.com/retrocabr/spree_pagarme_payment/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
