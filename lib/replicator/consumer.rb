require 'replicator/consumer/schema'
require 'replicator/consumer/mixin'
require 'replicator/receiver/observer'

module Replicator
  class Consumer
    attr_reader :schema

    delegate :_name, :collection, to: :schema
    alias :name :_name

    def initialize(schema)
      @schema = schema
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