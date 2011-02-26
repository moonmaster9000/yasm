module Yasm
  module Context
    class StateContainer
      attr_accessor :context
      attr_accessor :state #:nodoc:
      
      def initialize(options)
        @context = options[:context]
        @state   = options[:state]
      end

      def value; state; end

      def state
        fast_forward
        @state
      end

      def state=(s)
        if s.class == Class
          @state = s.new
        else
          @state = s
        end
      end

      def do!(*actions)
        actions.each do |action|
          fire! action
        end
      end

      private
      def fire!(action)
        fast_forward

        # Verify that the action is possible given the current state
        if !@state.reached_minimum_time_limit?
          raise Yasm::TimeLimitNotYetReached, "We're sorry, but the time limit on the state `#{@state}` has not yet been reached."
        elsif @state.class.final?
          raise Yasm::FinalStateException,    "We're sorry, but the current state `#{@state}` is final. It does not accept any actions."
        elsif !@state.class.is_allowed?(action.class)
          raise Yasm::InvalidActionException, "We're sorry, but the action `#{action.class}` is not possible given the current state `#{@state}`." 
        end

        action = Yasm::Manager.setup_action :action => action, :context => context, :state_container => self
        Yasm::Manager.change_state(
          :to => action.class.trigger_state,
          :on => self
        ) if action.class.trigger_state
        Yasm::Manager.execute_action action
      end

      def fast_forward
        while @state.passed_maximum_time_limit?
          # setup the action that should be performed when a state has lasted too long
          action = Yasm::Manager.setup_action(
            :action           => @state.class.maximum_duration_action,
            :context          => context,
            :state_container  => self
          )
          
          # update the state
          Yasm::Manager.change_state(
            :to => action.class.trigger_state || @state.class,
            :on => self,
            :at => @state.instantiated_at + @state.class.maximum_duration
          )

          # execute the action
          Yasm::Manager.execute_action action
        end
      end
    end
  end
end
