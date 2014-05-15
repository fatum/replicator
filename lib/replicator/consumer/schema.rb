module Replicator
  class Consumer
    class Schema
      attr_reader :caller, :collection, :_name, :adapter_proc, :receiver_proc

      def initialize(collection, caller, &block)
        @caller, @collection = caller, collection

        instance_eval &block
      end

      def name(name)
        @_name = name
      end

      def adapter(adapter)
        case adapter
        when Symbol
          require "replicator/consumer/#{adapter}"
          cls = "Replicator::Consumer::#{adapter.to_s.camelcase}".constantize.new(collection)

          @adapter_proc = Proc.new { |consumer| cls.call(consumer) }
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

      def receiver(handler)
        case handler
        when Symbol
          @receiver_proc = Proc.new { |packet| caller.send(handler, packet) }
        when Proc
          @receiver_proc = handler
        else
          if handler.respond_to? :call
            @receiver_proc = handler
          else
            raise "Unsupported handler: #{handler}"
          end
        end
      end
    end
  end
end