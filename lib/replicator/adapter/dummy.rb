require 'replicator/adapter/base'

module Replicator
  module Adapter
    class Dummy < Base
      attr_reader :name

      class_attribute :data
      self.data ||= {}

      def initialize(name)
        @name = name
      end

      def pop
        self.data[name] ||= []
        self.data[name].pop
      end

      def push(message)
        self.data[name] ||= []
        self.data[name] << message
      end

      def on_message(&block)
        if message = pop
          block.call Replicator::Packet.new(message)
        end
      end
    end
  end
end