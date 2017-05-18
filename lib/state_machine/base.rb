module StateMachine
  module Base
    module ClassMethods
      extend Forwardable

      def_delegators :@state_collection, :states, :initial_state

      def state_collection
        @state_collection ||= StateMachine::StateCollection.new
      end

      def event_collection
        @event_collection ||= StateMachine::EventCollection.new
      end

      def state_machine(&block)
        StateMachine::StateMachineFactory.define(state_collection, event_collection, &block)
        define_check_state_methods
        define_may_methods
        define_event_methods
      end

      def define_event_methods
        event_collection.all.each do |event|
          define_method(event.name) do
            raise InvalidTransition unless public_send("may_#{event.name}?")
            raise GuardCheckFailed if event.guard && !instance_eval(&event.guard)

            instance_eval(&event.before_callback) if event.before_callback
            @state = event.to
            instance_eval(&event.after_callback) if event.after_callback
          end
        end
      end

      def define_may_methods
        event_collection.all.each do |event|
          define_method("may_#{event.name}?") do
            event.from.include?(@state)
          end
        end
      end

      def define_check_state_methods
        state_collection.all.map(&:name).each do |new_state|
          define_method("#{new_state}?") do
            @state == new_state
          end
        end
      end
    end
  end
end
