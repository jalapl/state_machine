module StateMachine
  InvalidTransition = Class.new(StandardError)
  GuardCheckFailed = Class.new(StandardError)
  DuplicatedState = Class.new(StandardError)
  DuplicatedInitialState = Class.new(StandardError)
end
