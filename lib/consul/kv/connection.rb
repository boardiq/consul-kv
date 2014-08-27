require 'net/http'

module Consul
  module KV
    class Connection
      attr_reader :http

      def initialize
        raise 'Must configure Consul::KV' unless Consul::KV.config
        @http = Net::HTTP.new KV.config.consul_host, KV.config.consul_port
      end

      def put(key, value)
        response = standard_request :Put, key, false do |x|
          x.body = value
        end
      end

      def get(key, recurse = false)
        response = standard_request :Get, key, recurse
      end

      def delete(key, recurse = false)
        response = standard_request :Delete, key, recurse
      end

      protected

      def standard_request(verb, key, recurse)
        key = normalize_key key, recurse
        request = Net::HTTP.const_get(verb).new(key)
        yield(request) if block_given?
        http.request(request)
      end

      def normalize_key(key, recurse)
        key = "#{KV.config.consul_prefix}/#{key}"
        key = "#{key}?recurse" if recurse
        key
      end

    end
  end
end
