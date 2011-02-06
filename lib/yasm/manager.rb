module Yasm
  module Manager
    module_function

    def execute(options)
      context = options[:context]
      actions = options[:actions]
      state_container = options[:state_container]

      actions.each do |action|
        action         = action.new if action.class == Class
        action.context = context
        
        # Verify that the action is possible given the current state
        unless state_container.state.class.is_allowed?(action.class)
          raise "We're sorry, but the action `#{action.class}` is not possible given the current state `#{state_container.state}`." 
        end

        state_container.state = action.triggers.to_class if action.triggers
        action.execute 
      end
    end
  end
end
