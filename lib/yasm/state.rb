module Yasm
  module State
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def actions(*allowed_actions)
        @allowed_actions = allowed_actions
      end

      def allowed_actions
        @allowed_actions
      end

      def is_allowed?(action)
        return true if @allowed_actions.nil?
        @allowed_actions.include? action.to_sym
      end

      def final!
        @allowed_actions = []
      end

      def final?
        @allowed_actions == []
      end
    end

    def to_s
      self.class.to_s
    end
  end
end
