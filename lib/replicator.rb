require "replicator/version"

#require 'active_support/dependencies'
#require 'active_support/dependencies/autoload'
require 'active_support/core_ext'

module Replicator
  autoload :Consumer, 'replicator/consumer'
  autoload :Producer, 'replicator/producer'

  mattr_accessor :consumers
  mattr_accessor :producers

  self.consumers, self.producers = {}, []
end

require 'replicator/config'
