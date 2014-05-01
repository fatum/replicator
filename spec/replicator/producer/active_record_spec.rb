require 'spec_helper'
require 'active_record'

describe 'ActiveRecord integration' do
  class TempRecord < ActiveRecord::Base
    include Replicator::Producer::Mixin

    produce :temps do
      adapter :dummy
    end
  end

  class TempConsumer
    include Replicator::Consumer::Mixin

    consume :temps do
      adapter :dummy
      receiver proc { |packet| packet.state }
    end
  end

  before do
    ActiveRecord::Migration.create_table :temp_records do |t|
      t.integer :col
    end
  end

  after do
    ActiveRecord::Migration.drop_table :temp_records
  end

  describe 'after create' do
    it 'should produce state change' do
      TempRecord.create(col: 2)
      TempConsumer.consumer.start!.should eq('col' => 2, 'id' => 1)
    end
  end
end