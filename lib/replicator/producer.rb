require 'replicator/producer/schema'
require 'replicator/producer/mixin'

module Replicator
  class Producer
    attr_reader :schema, :events

    delegate :run_callbacks, :run_around_callbacks, to: :events

    class << self
      delegate :subscribe, to: Replicator::Events
    end

    def initialize(schema)
      @schema = schema
      @events = Replicator::Events.new(self)
    end

    # TODO extracto to replicator-consistent
    # Usage
    #
    # def update
    #   producer.transaction do
    #     model.update!
    #     sync :update, model
    #   end
    # end
    # def transaction
    #   run_around_callbacks :around_transaction, packet do
    #     yield
    #   end
    # end

    def sync(action, data)
      packet = Replicator.packet.new(action: action, state: data)

      run_callbacks :before_produce, packet

      data = schema.preparator_proc.call(data) if schema.preparator_proc.present?

      run_around_callbacks :around_produce, packet do
        schema.adapter_proc.call(action, data)
      end

      run_callbacks :after_produce, packet
    end
  end
end