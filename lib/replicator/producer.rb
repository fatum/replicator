require 'replicator/producer/schema'
require 'replicator/producer/mixin'

module Replicator
  class Producer
    attr_reader :schema

    def initialize(schema)
      @schema = schema
    end

    def sync(action, data)
      data = schema.preparator_proc.call(data) if schema.preparator_proc.present?
      schema.adapter_proc.call(action, data)
    end
  end
end