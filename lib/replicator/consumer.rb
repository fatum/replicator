require 'replicator/consumer/schema'
require 'replicator/consumer/mixin'

module Replicator
  class Consumer
    attr_reader :schema

    def initialize(schema)
      @schema = schema
    end

    def process(data)
      schema.receiver_proc.call(data)
    end
  end
end