require 'spec_helper'

describe Replicator::Consumer::Mixin do
  context 'mixed in model' do
    class DummyModel
      include Replicator::Consumer::Mixin

      consume :collection do
        name :dummy
        adapter :dummy

        receiver proc { |packet|
          :received
        }
      end
    end

    subject { DummyModel.new }

    it 'should create valid schema' do
      subject.consumer.
            process(Replicator.packet.new(action: :update, state: {id: 1})).
            should eq(:received)
    end
  end
end