require 'replicator/adapter/dummy'

module Replicator
  class Consumer
    class Dummy
      def initialize(collection)
        @driver = Replicator::Adapter::Dummy.new(collection)
      end

      def call(consumer)
        @driver.on_message do |message|
          consumer.process message
        end
      end
    end
  end
end