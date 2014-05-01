module Replicator
  class Packet
    attr_reader :input
    alias :serialize :input

    def initialize(input = {})
      @input = input
    end

    def action
      @input[:action]
    end

    def state
      @input[:state]
    end
  end
end