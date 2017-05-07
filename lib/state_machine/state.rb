module StateMachine
  module State
    module ClassMethods
      attr_accessor :states, :initial_state

      def state(state, **args)
        @states ||= []

        raise DuplicatedState if @states.include?(state)
        raise DuplicatedInitialState if args[:initial] && !@initial_state.nil?

        @states << state
        @initial_state = state if args[:initial]
        define_check_state_method(state)
      end

      def define_check_state_method(state)
        define_method("#{state}?") do
          @state == state
        end
      end
    end
  end
end
