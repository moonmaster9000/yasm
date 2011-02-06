module Yasm
  module Conversions
    module Symbol
      def to_class
        self.to_s.camelize.constantize
      end
    end
  end
end

class Symbol
  include Yasm::Conversions::Symbol
end
