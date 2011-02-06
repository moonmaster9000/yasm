module Yasm
  module Action
    attr_accessor :context

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

    def execute
      true
    end
  end
end
