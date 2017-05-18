require 'spec_helper'

describe StateMachine do
  let(:test_class) do
    Class.new do
      include StateMachine

      attr_accessor :before_flag, :after_flag

      state_machine do
        state :pending, initial: true
        state :confirmed, :removed

        event :confirm, before: :set_before_flag, after: proc { set_after_flag } do
          transitions from: [:pending], to: :confirmed
        end

        event :remove, guard: :removing_possible? do
          transitions from: :confirmed , to: :removed
        end
      end

      def set_before_flag
        @before_flag = true
      end

      def set_after_flag
        @after_flag = true
      end

      def removing_possible?
        false
      end

      def confirming_possible?
        true
      end
    end
  end

  let(:test_class_instance) { test_class.new }

  it 'returns a list of defined states' do
    expect(test_class.states).to eq(%i(pending confirmed removed))
  end

  it 'stores initial state if passed' do
    expect(test_class.initial_state).to eq(:pending)
  end

  it 'initiates each instance with initial state' do
    expect(test_class_instance.state).to eq(:pending)
  end

  it 'checks current instance state' do
    expect(test_class_instance.pending?).to be true
    expect(test_class_instance.confirmed?).to be false
  end

  it 'raises an error if state is defined more than once' do
    expect do
      Class.new do
        include StateMachine
        state_machine do
          state :pending
          state :pending
        end
      end
    end.to raise_error(StateMachine::DuplicatedState)
  end

  it 'raises an error if initial state is defined more than once' do
    expect do
      Class.new do
        include StateMachine
        state_machine do
          state :pending, initial: true
          state :draft, initial: true
        end
      end
    end.to raise_error(StateMachine::DuplicatedInitialState)
  end

  it 'raises an error if initial state is defined for more than new state in one line' do
    expect do
      Class.new do
        include StateMachine
        state_machine do
          state :pending, :draft, initial: true
        end
      end
    end.to raise_error(StateMachine::AmbiguousInitialState)
  end

  it 'changes state based on predefined event' do
    test_class_instance.confirm
    expect(test_class_instance.state).to eq(:confirmed)
  end

  it 'checks if a state transition is possible' do
    expect(test_class_instance.may_confirm?).to be true
    test_class_instance.confirm
    expect(test_class_instance.may_confirm?).to be false
  end

  it 'raises an error when transition is not possible' do
    test_class_instance.confirm
    expect { test_class_instance.confirm }.to raise_error(StateMachine::InvalidTransition)
  end

  it 'executes before callback when transition succeeds' do
    test_class_instance.confirm
    expect(test_class_instance.before_flag).to be true
  end

  it 'executes after callback when transition succeeds' do
    test_class_instance.confirm
    expect(test_class_instance.after_flag).to be true
  end

  it 'raises an error when guard check failed' do
    test_class_instance.confirm
    expect { test_class_instance.remove }.to raise_error(StateMachine::GuardCheckFailed)
  end
end
