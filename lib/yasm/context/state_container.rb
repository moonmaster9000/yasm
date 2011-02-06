module Yasm
  module Context
    class StateContainer
      attr_accessor :context
      
      def initialize(options)
        @context = options[:context]
        @state   = options[:state]
      end

      def current_state; @state; end
    end
  end
end
