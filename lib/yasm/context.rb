module Yasm
  module Context
    def self.included(base)
      base.extend ClassMethods
      if base.ancestors.include?(CouchRest::Model::Base) and !base.ancestors.include?(Yasm::Persistence::CouchRest::Model)
        base.send :include, Yasm::Persistence::CouchRest::Model
      end
    end

    module ClassMethods
      # for a simple, anonymous state 
      def start(state)
        state_configurations[ANONYMOUS_STATE] = StateConfiguration.new
        state_configurations[ANONYMOUS_STATE].start state
      end

      # for a named state
      def state(name, &block)
        raise ArgumentError, "The state name must respond to `to_sym`" unless name.respond_to?(:to_sym)
        name = name.to_sym
        state_configurations[name] = StateConfiguration.new 
        state_configurations[name].instance_eval &block
        
        raise "You must provide a start state for #{name}" unless state_configurations[name].start_state

        define_method(name) { state_container name }
      end

      # state configuration metadata
      def state_configurations
        @state_configurations ||= {}
      end
    end

    def do!(*actions)
      state.do! *actions
    end

    def state
      raise "This class has no anonymous state" unless self.class.state_configurations[ANONYMOUS_STATE] 
      state_container ANONYMOUS_STATE
    end

    private
    def state_containers
      @state_containers ||= {}
    end
    
    def state_container(id)
      unless state_containers[id]
        state_containers[id] = StateContainer.new :context => self 
        Yasm::Manager.change_state :to => self.class.state_configurations[id].start_state, :on => state_containers[id]
      end

      state_containers[id]
    end
  end
end
