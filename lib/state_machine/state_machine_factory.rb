module StateMachine
  class StateMachineFactory
    def self.define(state_collection, event_collection, &block)
      @state_collection = state_collection
      @event_collection = event_collection
      instance_eval(&block)
    end

    def self.state(*new_states, **args)
      raise DuplicatedState unless (@state_collection.states & new_states).empty?
      raise DuplicatedInitialState if args[:initial] && !@state_collection.initial_state.nil?
      raise AmbiguousInitialState if args[:initial] && new_states.size > 1

      new_states.each { |new_state| @state_collection.add_state(new_state, args[:initial]) }
    end

    def self.event(name, **args, &block)
      @event_collection.add_event(name, args, &block)
    end
  end
end
