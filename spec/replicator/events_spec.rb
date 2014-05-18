require 'spec_helper'

describe Replicator::Events do
  context 'when subscriptions exists' do
    subject { described_class.new(nil) }

    before do
      described_class.subscribe :test do |_, packet, action|
        $data << :cb1
        action.call
      end

      described_class.subscribe :test do |_, packet, action|
        $data << :cb2
        action.call
      end
    end

    it 'should run nested callbacks' do
      $data = []

      subject.run_around_callbacks :test, :packet do
        $data << :action
      end

      $data.should eq([:cb1, :cb2, :action])
    end
  end
end