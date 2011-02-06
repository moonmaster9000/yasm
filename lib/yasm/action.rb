module Yasm
  module Action
    attr_accessor :context, :state_container

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def triggers(state)
        @trigger_state = state
      end

      def trigger_state; @trigger_state; end
    end

    def triggers
      self.class.trigger_state
    end

    def trigger(state)
      Yasm::Manager.change_state :to => state, :on => state_container
    end

    def execute
      true
    end
  end
end
