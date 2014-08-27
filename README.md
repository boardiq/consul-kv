# Consul::KV

Consul::KV is a simple wrapper around Consul's KV store.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consul-kv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install consul-kv

## Usage

```ruby
Consul::KV.configure do |x|
  x.consul_host = 'http://127.0.0.1'
  x.consul_port = '8500'
  x.consul_prefix = 'v1/kv'
end

store = Consul::KV::Store.new
store['foo'] = bar  #=> { 'foo' => 'bar' }
store['foo']        #=> { 'foo' => 'bar' }
store.delete('foo') #=> true
```

## TODO
1. Switchable Datacenters
2. Atomic operations

## Contributing

1. Fork it ( https://github.com/[my-github-username]/consul-kv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
