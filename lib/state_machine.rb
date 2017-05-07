require 'state_machine/version'
require 'state_machine/state'
require 'state_machine/event'
require 'state_machine/exceptions'
require 'pry'

module StateMachine
  def self.included(base)
    base.extend(State::ClassMethods)
    base.extend(Event::ClassMethods)
  end

  attr_reader :state

  def initialize(*)
    @state = self.class.initial_state
  end
end
