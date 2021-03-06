# 3scale - API

[![Join the chat at https://gitter.im/IDTLabs/threescale_api](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/IDTLabs/threescale_api?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Gem Version](https://badge.fury.io/rb/3scale_api.svg)](http://badge.fury.io/rb/3scale_api)

This gem will allow developers to interact with 3Scale's APIs.


## Installation

Add this line to your application's Gemfile:

```ruby
gem '3scale_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install 3scale_api

## Configure

Initialize the settings as follows:

```ruby
require "3scale_api"
Threescale.configure do |config|
  config.provider_key = ENV["THREESCALE_PROVIDER_KEY"]
  config.base_url = ENV["THREESCALE_URL"]
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/threescale_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
