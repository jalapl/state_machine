require 'state_machine/version'
require 'state_machine/base'
require 'state_machine/state_machine_factory'
require 'state_machine/state_collection'
require 'state_machine/event_collection'
require 'state_machine/exceptions'
require 'pry'

module StateMachine
  def self.included(base)
    base.extend(Base::ClassMethods)
  end

  attr_reader :state

  def initialize(*)
    @state = self.class.initial_state
  end
end
