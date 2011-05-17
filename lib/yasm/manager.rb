module Yasm
  module Manager
    module_function

    def change_state(options)
      new_state       = options[:to]
      state_container = options[:on]
      state_time      = options[:at] || Time.now
      
      new_state = get_instance new_state
      new_state.instantiated_at = state_time
      new_state.context = state_container.context 
      state_container.state = new_state
    end
    
    def setup_action(options)
      action = options[:action]
      context = options[:context]
      state_container = options[:state_container]
      
      action = get_instance action
      action.context = context
      action.state_container = state_container
      action
    end
    
    def execute_action(action)
      action.execute
    end

    def get_instance(obj)
      obj = obj.to_class if obj.respond_to? :to_class
      obj = obj.new if obj.class == Class
      obj
    end
  end
end
