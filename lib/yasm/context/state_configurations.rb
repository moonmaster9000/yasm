module Yasm
  module Context
    class StateConfigurations < Hash
      def anonymous
        self[ANONYMOUS_STATE] ||= StateConfiguration.new
      end
    end
  end
end
