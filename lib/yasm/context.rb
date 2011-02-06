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
          loaded_state name
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
      raise "This class has no anonymous state" unless self.class.state_configurations.anonymous.start_state      
      loaded_state ANONYMOUS_STATE
    end

    private
    def states
      @states ||= {}
    end

    def loaded_state(id)
      unless states[id]
        states[id] ||= self.class.state_configurations[id].start_state.new 
        states[id].context = self
      end

      states[id]
    end
  end
end
