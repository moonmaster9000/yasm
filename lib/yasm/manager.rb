module Yasm
  module Manager
    module_function

    def change_state(options)
      new_state       = options[:to]
      state_container = options[:on]
      new_state = new_state.to_class if new_state.respond_to? :to_class

      state_container.state = new_state.new
    end
    
    def execute(options)
      context = options[:context]
      actions = options[:actions]
      state_container = options[:state_container]

      actions.each do |action|
        action                  = action.new if action.class == Class
        action.context          = context
        action.state_container  = state_container
        

        # Verify that the action is possible given the current state
        if state_container.state.class.final?
          raise "We're sorry, but the current state `#{state_container.state}` is final. It does not accept any actions."
        elsif !state_container.state.class.is_allowed?(action.class)
          raise "We're sorry, but the action `#{action.class}` is not possible given the current state `#{state_container.state}`." 
        end

        change_state :to => action.triggers.to_class, :on => state_container if action.triggers 
        action.execute 
      end
    end
  end
end
