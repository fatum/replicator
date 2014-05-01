require "bundler/gem_tasks"

task :environment do
  require 'replicator'
end

task :c => :environment do
  require 'pry'
  Pry.start
end

task :example => :environment do
  require 'replicator/consumer'

  class Updater < Replicator::Receiver::Observer
    def update(state)
      p "state updated to: #{state}"
    end
  end

  class Consumer
    include Replicator::Consumer::Mixin

    consume :test do
      adapter :dummy
      receiver Updater
    end
  end

  adapter = Replicator::Adapter::Dummy.new(:test)
  adapter.push action: :update, state: {id: 2}

  inst = Consumer.new
  inst.consumer.start!
end
