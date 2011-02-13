module Yasm
  module Context
    class StateContainer
      attr_accessor :context
      attr_accessor :state #:nodoc:
      
      def initialize(options)
        @context = options[:context]
        @state   = options[:state]
      end

      def value; @state; end
      
      def state=(s)
        if s.class == Class
          @state = s.new
        else
          @state = s
        end
      end

      def do!(*actions)
        actions = [self.state.class.maximum_duration_action] + actions if self.state.passed_maximum_time_limit?

        Yasm::Manager.execute(
          :context => context, 
          :state_container => self,
          :actions => actions
        )
      end
    end
  end
end
