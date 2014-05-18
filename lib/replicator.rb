require "replicator/version"

require 'active_support/core_ext'

module Replicator
  autoload :Consumer, 'replicator/consumer'
  autoload :Producer, 'replicator/producer'
  autoload :Events, 'replicator/events'
  autoload :Packet, 'replicator/packet'

  mattr_accessor :consumers
  mattr_accessor :producers
  mattr_accessor :packet # Extesions could provide specific packet class

  self.consumers, self.producers = {}, []
  self.packet = Packet
end

require 'replicator/config'
