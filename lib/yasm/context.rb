module Yasm
  module Context
    
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :possible_states
      
      def states(*args)
        return self.possible_states.dup if args.empty?
        raise "You may only pass states that include Yasm::State to the `states` class method" if args.any? {|s| !(s.ancestors.include? Yasm::State)}

        self.possible_states = args.dup
      end
    end

    def states
      self.class.states
    end

    def do!(*actions)
      Yasm::Manager.execute :context => self, :actions => actions
    end
  end
end
