require 'aasm'

class Order < ApplicationRecord
  include AASM
  include AasmPlus::Stateable

  aasm no_direct_assignment: false, column: 'state' do
    before_all_events :set_related_data
    after_all_transitions :log_state_change

    state :first, :initial => true
    state :second

    event :go do
      transitions :from => :first, :to => :second
    end
  end
end