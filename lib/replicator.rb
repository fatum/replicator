require "replicator/version"

require 'active_support/core_ext'

module Replicator
  autoload :Consumer, 'replicator/consumer'
  autoload :Producer, 'replicator/producer'
  autoload :Events, 'replicator/events'

  mattr_accessor :consumers
  mattr_accessor :producers

  self.consumers, self.producers = {}, []
end

require 'replicator/config'
