module Replicator
  class Producer
    class Schema
      attr_reader :caller, :collection, :consumers, :adapter_proc, :preparator_proc

      def initialize(collection, caller, &block)
        @caller, @collection = caller, collection

        instance_eval &block
      end

      def consumers(*_consumers)
        @consumers = _consumers
      end

      def adapter(adapter)
        case adapter
        when Symbol
          require "replicator/producer/#{adapter}"
          cls = "Replicator::Producer::#{adapter.to_s.camelcase}".constantize.new(collection, consumers)

          @adapter_proc = Proc.new { |action, data| cls.call(action, data) }
        when Proc
          @adapter_proc = adapter
        else
          if handler.respond_to? :call
            @adapter_proc = handler
          else
            raise "Unsupported adapter: #{adapter}"
          end
        end
      end

      def preparator(handler)
        case handler
        when Symbol
          @preparator_proc = Proc.new { |data| caller.send(handler, data) }
        when Proc
          @preparator_proc = handler
        else
          if handler.respond_to? :call
            @preparator_proc = handler
          else
            raise "Unsupported handler: #{handler}"
          end
        end
      end
    end
  end
end