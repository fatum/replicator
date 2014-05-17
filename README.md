# Replicator

A library for creating transparent interfaces for state replication.

Works with any kind of message queue for synching changes: aws sqs, kafka, amqp, sidekiq. Custom adapters make it trivial to use other MQs.

Also, replicator-versioner provides extensions for ensuring eventual consistency. Should an entity update but replication to another service fail, the consuming service can check its entity's version against the producer's before proceeding with its task at hand.

## Installation

Add this line to your application's Gemfile:

    gem 'replicator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install replicator

## Usage

```ruby
class Web::Offer < ActiveRecord::Base
  include Replicator::Producer::Mixin

  produce :offers do
    consumers :ad_server, :rewards
    adapter :sidekiq # can be any callable object -> adapter YourProducerImplementation
    preparator :prepare

    adapter proc { |action, data|
      # send
    }
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
  end
end

```

# TODO

- [ ] SQS adapter
- [x] Sidekiq adapter http://github.com/fatum/replicator-sidekiq
- [ ] Lifecycle management (for plugin development)
- [ ] Bulk consuming
- [ ] State versions
- [ ] Global syncing

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
