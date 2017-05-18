module StateMachine
  State = Struct.new(:name, :initial)

  class StateCollection
    def initialize
      @states = []
    end

    def add_state(name, initial)
      @states << State.new(name, initial)
    end

    def initial_state
      @states.find { |state| state.initial }&.name
    end

    def all
      @states
    end

    def states
      all.map(&:name)
    end

    def size
      all.size
    end
  end
end
