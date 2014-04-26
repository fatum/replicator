# Replicator

TODO: Write a gem description

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
  include Replicator::Producer

  produce :offers do
    # default
    # primary_key :id
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
  include Replicator::Consumer

  consume :offers do
    # default
    # primary_key :id # object should respond_to :id
    adapter :sidekiq
    receiver :receive # can be method or any callable object
  end

  def receive(action, data)
    offer = Offer.find(data.id)
    offer.status = data.status
    offer.save
  end
end

redis_offer = Offer.find(1)
redis_offer.last_version?

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
