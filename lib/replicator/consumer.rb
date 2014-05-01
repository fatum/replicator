require 'replicator/consumer/schema'
require 'replicator/consumer/mixin'
require 'replicator/receiver/observer'

module Replicator
  class Consumer
    attr_reader :schema

    def initialize(schema)
      @schema = schema
    end

    def process(data)
      schema.receiver_proc.call(data)
    end

    # Should start consuming state changes
    # usign adapter
    def start!
      schema.adapter_proc.call(self)
    end
  end
end