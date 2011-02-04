module Yasm
  module Context
    
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :default_state

      def start(state_klass)
        raise ArgumentError, "You may only pass a descendent of Yasm::State to the ##start method." unless state_klass.ancestors.include?(Yasm::State)
        self.default_state = state_klass
      end
    end

    def do!(*actions)
      #Yasm::Manager.execute :context => self, :actions => actions
    end
  end
end
