require 'spec_helper'

describe Replicator::Producer::Mixin do
  describe '#produce' do
    class DummyProducerModel
      include Replicator::Producer::Mixin

      def initialize(state = {})
        @state = state
      end

      def update(params)
        @state.merge!(params)

        producer.sync :update, @state
      end

      produce :collection do
        adapter :dummy

        # when empty (by default) use fanout
        # notification

        consumers []
      end
    end

    class DummyConsumerModel
      include Replicator::Consumer::Mixin

      consume :collection do
        name :temp
        adapter :dummy
        receiver proc { |packet| packet.state }
      end
    end

    it 'should create valid schema' do
      model = DummyProducerModel.new(id: 2)
      model.update id: 3

      DummyConsumerModel.consumer.receiving.should eq(id: 3)
    end
  end
end