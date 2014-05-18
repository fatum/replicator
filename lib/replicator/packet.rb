module Replicator
  class Packet
    attr_reader :input

    def initialize(input)
      @input = input

      if !input.instance_of?(Hash)
        @input = unserialize
      end
    end

    def action
      @input[:action]
    end

    def state
      @input[:state]
    end

    def serialize
      @input.to_json
    end

    def unserialize
      ActiveSupport::JSON.decode(@input)
    end
  end
end