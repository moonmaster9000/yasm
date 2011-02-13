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

      def minimum(time)
        raise(
          ArgumentError,
          "You must provide a Fixnum to the ##minimum method (represents number of seconds). For example: 2.minutes"
        ) unless time.kind_of?(Fixnum)

        @state_minimum_duration = time
      end

      def minimum_duration
        @state_minimum_duration
      end
    end
    
    attr_accessor :instantiated_at

    def to_s
      self.class.to_s
    end

    def reached_minimum_time_limit?
      return true unless self.class.minimum_duration 
      (Time.now - instantiated_at) >= self.class.minimum_duration 
    end
  end
end
