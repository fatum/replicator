module Replicator
  module Receiver
    class Observer
      def self.call(packet)
        _receiver = new
        _receiver.send packet.action, packet.state
      end
    end
  end
end