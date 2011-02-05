module Yasm
  module Context
    
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def start(state)
        state_configurations.anonymous.start state
      end

      def state(name, &block)
        raise ArgumentError, "The state name must respond to `to_sym`" unless name.respond_to?(:to_sym)
        name = name.to_sym
        state_configurations[name] = StateConfiguration.new 
        state_configurations[name].instance_eval &block if block
        define_method(name) do
          unless states[name]
            states[name] ||= self.class.state_configurations[name].start_state.new 
            states[name].context = self
          end
          states[name]
        end
      end

      def state_configurations
        @state_configurations ||= StateConfigurations.new
      end
    end

    def do!(*actions)
      #Yasm::Manager.execute :context => self, :actions => actions
    end

    def state
      unless states[:yasm_anonymous_state]
        states[:yasm_anonymous_state] ||= self.class.state_configurations[:yasm_anonymous_state].start_state.new 
        states[:yasm_anonymous_state].context = self
      end

      states[:yasm_anonymous_state]
    end

    private
    def states
      @states ||= {}
    end
  end
end
