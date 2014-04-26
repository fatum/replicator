require 'spec_helper'

describe Replicator::Consumer::Mixin do
  context 'mixed in model' do
    class DummyModel
      include Replicator::Consumer::Mixin

      consume :collection do
        adapter proc { |collection, action, state|
          # packet = Replicator::Packet.new(action, state)
          # kafka.push collection, packet
        }

        receiver :receive
      end

      def self.receive(data)
        :received
      end
    end

    subject { DummyModel.new }

    it 'should create valid schema' do
      subject.consumer.process({some_data: :ok}).should eq(:received)
    end
  end
end