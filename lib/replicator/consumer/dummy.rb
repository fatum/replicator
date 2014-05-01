require 'replicator/adapter/dummy'

module Replicator
  class Consumer
    class Dummy
      def initialize(collection)
        @adapter = Replicator::Adapter::Dummy.new(collection)
      end

      def call(consumer)
        @adapter.on_message do |message|
          consumer.process message
        end
      end
    end
  end
end