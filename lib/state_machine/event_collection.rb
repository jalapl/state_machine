module StateMachine
  Event = Struct.new(:name, :from, :to, :before_callback, :after_callback, :guard)

  class EventCollection
    def initialize
      @events = []
    end

    def add_event(name, args, &block)
      transitions = instance_eval(&block)
      @events << Event.new(
        name,
        Array(transitions[:from]),
        transitions[:to],
        args[:before],
        args[:after],
        args[:guard]
      )
    end

    def all
      @events
    end

    def transitions(**args)
      args
    end

    def size
      all.size
    end
  end
end
