require 'active_record'

module Replicator
  class Producer
    module ActiveRecord
      extend ActiveSupport::Concern

      included do
        after_commit :sync_update, on: :update
        after_commit :sync_create, on: :create
        after_commit :sync_destroy, on: :destroy

        def sync_update
          producer.sync :update, attributes
        end

        def sync_create
          producer.sync :create, attributes
        end

        def sync_destroy
          producer.sync :destroy, attributes
        end
      end
    end
  end
end