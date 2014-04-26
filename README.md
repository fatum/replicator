# Replicator

This library create transparent interface for state replication.

You can use any kind of message queue for changes delivery.
Like aws sqs, kafka, amqp, sidekiq or your custom adapter for unsupported MQ.

Also, replicator-versioner provide extension for fixing eventual consistency
For example, one service after updating entity state (user's data) publish task
using message queue to another service to notify all user's subscribers about changes.

But, when entity's state not replicated to service we cannot process task correctly and
should guarantee what producer's and publisher's versions are same.

## Installation

Add this line to your application's Gemfile:

    gem 'replicator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install replicator

## Usage

```
class Web::Offer < ActiveRecord::Base
  include Replicator::Producer::Mixin

  produce :offers do
    consumers [:ad_server, :rewards]
    adapter :sidekiq # can be any callable object -> adapter YourProducerImplementation
    preparator :prepare
  end

  def prepare
    # prepare data for publishing
    # e.x. we have publish some relations data

    attributes.merge(
      countries: countries.slice(:id, :code),
      browsers: browsers.slice(:id, :name),
      oses: oses.slice(:id, :name)
    )
  end
end

class ConsumedOffer
  include Redis::Objects
  include Replicator::Consumer::Mixin

  consume :offers do
    adapter :sidekiq

    receiver proc { |action, state|
      when action
      case :update
        offer = Offer.find(state.id)
        offer.status = state.status
        offer.save
      end
    }
  end
end

# For AWS replicator
bundle exec replicator subscribe

# For sidekiq
# should create workers classes on fly
# http://blog.revathskumar.com/2013/05/ruby-create-classes-on-fly.html
bundle exec sidekiq -q replicator-offers

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
