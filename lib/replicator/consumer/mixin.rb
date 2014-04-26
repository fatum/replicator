module Replicator
  class Consumer
    module Mixin
      extend ActiveSupport::Concern

      included do
        class_attribute :consumer
        class_attribute :replicator # config instance

        self.replicator ||= Replicator::Config

        def self.consume(collection, &block)
          self.consumer ||= begin
            schema = Replicator::Consumer::Schema.new(collection, self, &block)
            Replicator::Consumer.new(schema)
          end
        end
      end
    end
  end
end