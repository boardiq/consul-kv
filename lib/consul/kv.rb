require 'consul/kv/version'
require 'consul/kv/configuration'
require 'consul/kv/connection'
require 'consul/kv/store'

module Consul
  module KV
    class << self
      attr_accessor :config

      def configure(&block)
        self.config ||= Configuration.new
        yield(config)
      end
    end
  end
end
