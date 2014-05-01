module Replicator
  class Producer
    module Mixin
      extend ActiveSupport::Concern

      included do
        class_attribute :producer
        class_attribute :replicator # config instance

        self.replicator ||= Replicator::Config

        def self.produce(collection, &block)
          self.producer ||= begin
            schema = Replicator::Producer::Schema.new(collection, self, &block)
            Replicator::Producer.new(schema)
          end
        end
      end
    end
  end
end