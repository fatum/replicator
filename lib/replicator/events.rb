module Replicator
  class Events
    attr_reader :publisher
    class_attribute :events
    self.events ||= {}

    def initialize(publisher)
      @publisher = publisher
    end

    def self.subscribe(event, &block)
      self.events[event] ||= []
      self.events[event] << block
    end

    def run_callbacks(event, packet)
      find(event).reverse.each do |cb|
        cb.call(producer, packet)
      end
    end

    def run_around_callbacks(event, packet, &block)
      events = find(event).dup
      events << block

      events.reverse!

      recursive_callback packet, events.pop, events
    end

    private

    def find(event)
      self.class.events[event] || []
    end

    def recursive_callback(packet, cb, stack)
      cb.call(publisher, packet, proc { |_, _, c|
        recursive_callback(packet, stack.pop, stack) if stack.any?
      })
    end
  end
end