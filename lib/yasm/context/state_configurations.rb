module Yasm
  module Context
    class StateConfigurations < Hash
      def anonymous
        self[:yasm_anonymous_state] ||= StateConfiguration.new
      end
    end
  end
end
