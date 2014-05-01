module Replicator
  class Producer
    class Dummy
      def initialize(collection, consumers)
        @collection, @consumers = collection, consumers

        if consumers.present?
          @adapters = consumers.map { |c| Replicator::Adapter::Dummy.new("#{collection}_#{c}") }
        else
          @adapters = [Replicator::Adapter::Dummy.new(collection)]
        end
      end

      def call(action, data)
        @adapters.each { |a| a.push Replicator::Packet.new(action: action, state: data) }
      end
    end
  end
end