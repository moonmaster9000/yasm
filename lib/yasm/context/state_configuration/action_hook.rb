module Yasm
  module Context
    class StateConfiguration
      class ActionHook
        attr_reader :method

        def initialize(method, options={})
          @method = method
          @only = [options[:only]].flatten.compact
          @except = [options[:except]].flatten.compact
        end

        def applicable?(action)
          if @only.empty? and @except.empty?
            true
          elsif !@only.empty?
            if @only.include?(action)
              true
            else
              false
            end
          elsif !@except.empty?
            if @except.include?(action)
              false
            else
              true
            end
          end
        end
      end
    end
  end
end
