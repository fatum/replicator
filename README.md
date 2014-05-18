# Replicator

[![Code Climate](https://codeclimate.com/github/fatum/replicator.png)](https://codeclimate.com/github/fatum/replicator)

A library for creating transparent interfaces for state replication.

Works with any kind of message queue for synching changes: aws sqs, kafka, amqp, sidekiq. Custom adapters make it trivial to use other MQs.

Also, replicator-versioner provides extensions for ensuring eventual consistency. Should an entity update but replication to another service fail, the consuming service can check its entity's version against the producer's before proceeding with its task at hand.

## Installation

Add this line to your application's Gemfile:

    gem 'replicator', github: 'fatum/replicator'

And then execute:

    $ bundle

## Features

* Simple
* Framework agnostic
* Adapter agnostic
* Sequential Consistency - Updates from a publisher will be applied in the order that they were sent for record

## Usage

```ruby
class Web::Offer < ActiveRecord::Base
  include Replicator::Producer::Mixin

  produce :offers do
    consumers :ad_server, :rewards
    adapter :sidekiq
    preparator :prepare
  end

  def prepare
    # prepare data for publishing
    # e.x. here we publish some associations data

    attributes.merge(
      countries: countries.slice(:id, :code),
      browsers: browsers.slice(:id, :name),
      oses: oses.slice(:id, :name)
    )
  end
end

class Updater < Replicator::Receiver::Observer
  def update(state)
    p "state updated to: #{state}"
  end
end

class ConsumedOffer
  include Redis::Objects
  include Replicator::Consumer::Mixin

  consume :offers do
    adapter :sidekiq
    receiver Updater
    # or receive proc { |packet| p "#{packet.action}: #{packet.state}" }
  end
end

```

## Lifecycle management

Replicator::Producer provides callbacks for subscribing

* `Replicator::Producer.subscribe(:around_produce) { |producer, packet, block| }`
* `Replicator::Producer.subscribe(:after_produce) { |producer, packet| }`
* `Replicator::Producer.subscribe(:before_produce) { |producer, packet| }`

Replicator::Consumer provides callbacks for subscribing

* `Replicator::Consumer.subscribe(:around_consume) { |producer, packet, block| }`
* `Replicator::Consumer.subscribe(:after_consume) { |producer, packet| }`
* `Replicator::Consumer.subscribe(:before_consume) { |producer, packet| }`

For example, `replicator-consistency` uses callback around_produce
```ruby

Replicator::Publisher.subscribe :around_produce do |publisher, packet, cb|
  begin
    cb.call
    packet.commit!
  rescue StandardError
    # Should mark packet as error
    # 1. db transaction rollback and adapter had pushed message to consumers
    # 2. if consumer adapter receive invalid message it should check packet.error? before processing
    packet.error!
  end
end

Replicator::Publisher.subscribe :around_produce do |publisher, packet, cb|
  if publisher.use_active_record?
    ActiveRecord::Base.transaction do
      # We should guarantee that all changes for record would applied sequentially
      packet.mutate!
      cb.call
    end
  else
    packet.mutate!
    cb.call
  end
end
```

## Configuring

You could use custom Packet class

```ruby
Replicator.packet = CustomPacketClass
```

# TODO

- [x] Sidekiq adapter http://github.com/fatum/replicator-sidekiq
- [x] Lifecycle management (for plugin development)
- [ ] Consistency
- [ ] SQS adapter
- [ ] Global syncing

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
