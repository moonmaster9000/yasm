module Yasm
  module Context
    class StateConfiguration
      attr_reader :start_state, :after_actions, :before_actions
      
      def initialize(start_state = nil)
        @start_state = start_state
        @after_actions = []
        @before_actions = []
      end

      def start(state)
        @start_state = state
      end

      def after_action(method, options={})
        @after_actions << ActionHook.new(method, options)
      end

      def before_action(method, options={})
        @before_actions << ActionHook.new(method, options)
      end
    end
  end
end
