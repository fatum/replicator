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

      def push(packet)
        self.data[name] ||= []
        self.data[name] << packet
      end

      def on_message(&block)
        if packet = pop
          block.call packet
        end
      end
    end
  end
end