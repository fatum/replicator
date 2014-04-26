require "replicator/version"

#require 'active_support/dependencies'
#require 'active_support/dependencies/autoload'
require 'active_support/core_ext'

module Replicator
  autoload :Consumer, 'replicator/consumer'
  autoload :Producer, 'replicator/producer'

  # Your code goes here...
end

require 'replicator/config'
