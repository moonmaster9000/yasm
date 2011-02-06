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
        
        state_container.state = action.triggers if action.triggers
        action.execute 
      end
    end
  end
end
