module Consul
	module KV
		class Configuration
      attr_accessor :consul_host, :consul_port,
                    :consul_prefix

      def initialize
        @consul_host    = 'http://127.0.0.1'
        @consul_port    = '8500'
        @consul_prefix  = '/v1/kv'
      end
		end
	end
end
