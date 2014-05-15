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

            raise "Specify consumer's name!" if schema._name.blank?

            Replicator::Consumer.new(schema).tap do |consumer|
              Replicator.consumers[schema._name] = consumer
            end
          end
        end
      end
    end
  end
end