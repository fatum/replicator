require 'replicator/packet'

module Replicator
  module Adapter
    class Base
      def push(*data)
        raise NotImplementedError
      end

      def pop
        raise NotImplementedError
      end

      def on_message(&block)
        raise NotImplementedError
      end
    end
  end
end