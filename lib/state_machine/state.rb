module StateMachine
  module State
    module ClassMethods
      attr_accessor :states, :initial_state

      def state(*new_states, **args)
        @states ||= []

        raise DuplicatedState unless (@states & new_states).empty?
        raise DuplicatedInitialState if args[:initial] && !@initial_state.nil?
        raise AmbiguousInitialState if args[:initial] && new_states.size > 1

        @states = (@states << new_states).flatten
        @initial_state = new_states.first if args[:initial]
        define_check_state_method(new_states)
      end

      def define_check_state_method(new_states)
        new_states.each do |new_state|
          define_method("#{new_state}?") do
            @state == new_state
          end
        end
      end
    end
  end
end
