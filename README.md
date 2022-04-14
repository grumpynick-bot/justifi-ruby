# JustiFi Ruby ![Coverage](https://justifi-gem-assets.s3.us-east-2.amazonaws.com/coverage_badge_total.svg)

The JustiFi gem provides a simple way to access JustiFi API for apps written in Ruby language. 
It includes a pre-defined set of modules and classes that are essentially wrapped versions of our API resources.

## Installation

From the command line:
```bash
gem install justifi --version "0.3.1" --source "https://rubygems.pkg.github.com/justifi-tech"
```
OR

Add these lines to your application's Gemfile:

```ruby
source "https://rubygems.pkg.github.com/justifi-tech" do
  gem "justifi", "0.3.1"
end
```
And then execute:

    $ bundle install


## Setup

The gem needs to be configured with your `client_id` and `client_secret` in order to access JustiFi API resources.

Set `Justifi.client_id` and `Justifi.client_secret`:

```ruby
require 'justifi'

Justifi.client_id = 'live_13...'
Justifi.client_secret = 'live_TDYj_wdd...'
```

OR just use the `Justifi.setup` method to set all at once:


```ruby
require 'justifi'

# setup
Justifi.setup(client_id:     ENV["JUSTIFI_CLIENT_ID"],
              client_secret: ENV["JUSTIFI_CLIENT_SECRET"])
```


## Create Payment

There are two ways to create a payment:

1. Create with tokenized payment method:

```ruby
payment_params = {
  amount: 1000,
  currency: "usd",
  capture_strategy: "automatic",
  email: "example@example.com",
  description: "Charging $10 on Example.com",
  payment_method: {
    token: "#{tokenized_payment_method_id}"
  }
}

Justifi::Payment.create(params: payment_params)
```

2. Create with full payment params:

```ruby
payment_params = {
  amount: 1000,
  currency: "usd",
  capture_strategy: "automatic",
  email: "example@example.com",
  description: "Charging $10 on Example.com",
  payment_method: {
    card: {
      name: "JustiFi Tester",
      number: "4242424242424242",
      verification: "123",
      month: "3",
      year: "2040",
      address_postal_code: "55555"
    }
  }
}

Justifi::Payment.create(params: payment_params)
```

## Idempotency Key

You can use your own idempotency-key when creating payments.

```ruby
payment_params = {
  amount: 1000,
  currency: "usd",
  capture_strategy: "automatic",
  email: "example@example.com",
  description: "Charging $10 on Example.com",
  payment_method: {
    card: {
      name: "JustiFi Tester",
      number: "4242424242424242",
      verification: "123",
      month: "3",
      year: "2040",
      address_postal_code: "55555"
    }
  }
}

Justifi::Payment.create(params: payment_params, idempotency_key: "my_idempotency_key")
```

IMPORTANT: The gem will generate an idempotency key in case you don't want to use your own.

## Create Payment Refund

In order to create a refund, you will need an amount, a payment_id ( `py_2aBBouk...` ).

```ruby
payment_params = {
  amount: 1000,
  currency: "usd",
  capture_strategy: "automatic",
  email: "example@example.com",
  description: "Charging $10 on Example.com",
  payment_method: {
    card: {
      name: "JustiFi Tester",
      number: "4242424242424242",
      verification: "123",
      month: "3",
      year: "2040",
      address_postal_code: "55555"
    }
  }
}

payment_id = Justifi::Payment.create(params: payment_params).data[:id] # get the payment id
reason     = ['duplicate', 'fraudulent', 'customer_request'] # optional: one of these
amount     = 1000

Justifi::Payment.create_refund( amount: 1000, reason: reason, payment_id: payment_id )
```

## Listing Resources

All top-level API resources have support for bulk fetches via `array` API methods.
JustiFi uses cursor based pagination which supports `limit`, `before_cursor` and `after_cursor`.
Each response will have a `page_info` object that contains the `has_next` and `has_previous` fields,
you can find more information about this on [JustiFi's Developer Portal](https://developer.justifi.ai/#section/Pagination).

### List Payments

```ruby
payments = Justifi::Payment.list

# pagination with end_cursor

query_params = {
  limit: 15,
  after_cursor: payments.data[:page_info][:end_cursor],
}

payments = Justifi::Payment.list(params: query_params)
```


### List Refunds

```ruby
refunds = Justifi::Refund.list

# pagination
refunds = refunds.next_page
refunds = refunds.previous_page
```


## Get resource by id

```ruby
payment = Justifi::Payment.get(payment_id: 'py_xyz')
refund = Justifi::Refund.get(refund_id: 're_xyz')
```


## Contributing

### Release a new version of the gem

Follow the steps below to make a release:

1. Increment the version number in `lib/justifi/version.rb`
2. Run `bundle`
3. Commit the following file changes to your branch
  - `Gemfile.lock`
  - `lib/justifi/version.rb`
4. Create and Merge your PR to `main`

After this, the `.github/workflows/build_and_release.yml` will tag and release
the gem to github packages.


## Code of Conduct

Everyone interacting in the JustApi project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the [code of conduct][].
