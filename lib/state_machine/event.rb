module StateMachine
  module Event
    module ClassMethods
      attr_accessor :events

      def event(name, **args, &block)
        @events ||= {}
        @events[name] = instance_eval(&block)

        define_event_method(name, args)
        define_may_method(name)
      end

      def define_event_method(name, args)
        define_method(name) do
          raise InvalidTransition unless public_send("may_#{name}?")
          guard = args[:guard]
          raise GuardCheckFailed if guard && !instance_eval(&guard)

          before_callback = args[:before]
          instance_eval(&before_callback) if before_callback

          @state = self.class.events[name][:to]

          after_callback = args[:after]
          instance_eval(&after_callback) if after_callback
        end
      end

      def define_may_method(name)
        define_method("may_#{name}?") do
          Array(self.class.events[name][:from]).include?(@state)
        end
      end

      def transitions(**args)
        args
      end
    end
  end
end
