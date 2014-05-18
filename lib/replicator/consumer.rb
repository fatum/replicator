require 'replicator/consumer/schema'
require 'replicator/consumer/mixin'
require 'replicator/receiver/observer'

module Replicator
  class Consumer
    attr_reader :schema, :events

    delegate :_name, :collection, to: :schema
    alias :name :_name

    delegate :run_callbacks, :run_around_callbacks, to: :events

    class << self
      delegate :subscribe, to: Replicator::Events
    end

    def initialize(schema)
      @schema = schema
      @events = Replicator::Events.new(self)
    end

    def process(data)
      schema.receiver_proc.call(data)
    end

    # Should start consuming state changes
    # using adapter
    def receiving
      schema.adapter_proc.call(self)
    end
  end
end