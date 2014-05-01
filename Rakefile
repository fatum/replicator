require 'rubygems'
require 'bundler/setup'

Bundler.require :default, :development

require "bundler/gem_tasks"
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

ActiveRecord::Base.establish_connection YAML.load_file('config/database.yml')['development']
ActiveRecord::Base.logger = Logger.new(STDOUT)

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
