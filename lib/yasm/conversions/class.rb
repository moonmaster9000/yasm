module Yasm
  module Conversions
    module Class
      def to_sym
        self.to_s.underscore.to_sym
      end

      def to_class
        self
      end
    end
  end
end

class Class
  include Yasm::Conversions::Class
end
