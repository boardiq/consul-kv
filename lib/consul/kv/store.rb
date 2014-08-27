require 'json'
require 'base64'

module Consul
  module KV
    class Store
      CannotReadError   = Class.new(StandardError)
      CannotWriteError  = Class.new(StandardError)
      CannotDeleteError = Class.new(StandardError)

      def initialize
        @mutex = Mutex.new
        @conn  = Connection.new
      end

      def get(key)
        resp = nil
        @mutex.synchronize do
          resp = conn.get key, true
        end
        return nil if resp.kind_of?(Net::HTTPNotFound)
        raise CannotReadError unless resp.kind_of?(Net::HTTPSuccess)
        json = JSON.parse(resp.body)
        if json.size > 1 || json.first['Key'] != key
          json.each_with_object({}) do |item, hsh|
            hsh[item['Key'].gsub(/\A#{key}\//, '')] = Base64.decode64(item['Value'])
          end
        else
          Base64.decode64 json.first['Value']
        end
      end
      alias :[] :get

      def put(key, value)
        resp = nil
        @mutex.synchronize do
          resp = conn.put key, value
        end
        raise CannotWriteError unless resp.kind_of?(Net::HTTPSuccess)
        get key
      end
      alias :[]= :put

      def delete(key)
        resp = nil
        @mutex.synchronize do
          resp = conn.delete key, true
        end
        raise CannotDeleteError unless resp.kind_of?(Net::HTTPSuccess)
      end

      private

      attr_reader :conn

    end
  end
end
