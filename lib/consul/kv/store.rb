require 'json'
require 'base64'

module Consul
  module KV
    class Store
      CannotReadError   = Class.new(StandardError)
      CannotWriteError  = Class.new(StandardError)
      CannotDeleteError = Class.new(StandardError)

      def initialize(prefix = nil)
        @mutex  = Mutex.new
        @conn   = Connection.new
        @prefix = prefix
      end

      def get(key)
        resp = nil
        @mutex.synchronize do
          resp = conn.get build(key), true
        end
        return nil if resp.kind_of?(Net::HTTPNotFound)
        raise CannotReadError unless resp.kind_of?(Net::HTTPSuccess)
        json = JSON.parse(resp.body)
        if json.size > 1 || json.first['Key'] != build(key)
          json.each_with_object({}) do |item, hsh|
            hsh[item['Key'].gsub(/\A#{build(key)}\//, '')] = Base64.decode64(item['Value'])
          end
        else
          Base64.decode64 json.first['Value']
        end
      end
      alias :[] :get

      def put(key, value)
        resp = nil
        @mutex.synchronize do
          resp = conn.put build(key), value
        end
        raise CannotWriteError unless resp.kind_of?(Net::HTTPSuccess)
        get key
      end
      alias :[]= :put

      def delete(key)
        resp = nil
        @mutex.synchronize do
          resp = conn.delete build(key), true
        end
        raise CannotDeleteError unless resp.kind_of?(Net::HTTPSuccess)
        true
      end

      private

      attr_reader :conn

      def build key
        return key unless @prefix
        return @prefix if key == ''
        "#{@prefix}/#{key}"
      end

    end
  end
end
