module Replicator
  class Config
    class_attribute :adapters

    self.adapters ||= []

    # Usage
    # Replicator::Config.configure do
    #   adapters = [:sidekiq, :sqs, :amqp]
    # end
    def self.configure(&block)
      block.call self
    end
  end
end