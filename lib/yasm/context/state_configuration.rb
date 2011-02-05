module Yasm
  module Context
    class StateConfiguration
      attr_reader :start_state

      def initialize(start_state = nil)
        @start_state = start_state
      end

      def start(state)
        @start_state = state
      end
    end
  end
end
