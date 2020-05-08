# how to use
# in model
# include AASM
# include AasmPlus::Stateable
# 在model的aasm配置内添加
# before_all_events :set_related_data
# after_all_transitions :log_state_change
module AasmPlus
  module Stateable
    extend ActiveSupport::Concern


    STATE_HASH = {

    }.freeze


    included do
      include Comparable
      has_many :state_chains, as: :stateable, class_name: "AasmPlus::StateChain"

      attr_accessor :operator
      attr_accessor :aasm_args #状态迁移附加数据

      scope :of_state, lambda {|state|
        where(self.aasm.attribute_name => state)
      }

      # 输入state数组
      scope :of_states, lambda {|states|
        where({self.aasm.attribute_name => states})
      }

      def self.states
        self.aasm.states.map {|s| s.name}
      end
    end

    def trigger_event!(event, operator, args = {})
      all_events = self.aasm.events.map(&:name)
      raise ArgumentError.new('无效event') unless all_events.include?(event.to_sym)
      public_send("#{event.to_s}!".to_sym, operator, args)
    end

    # 状态比较
    def <=>(state_str)
      klass = self.class
      if state_str.is_a?(String) || state_str.is_a?(Symbol)
        if klass.states.include?(state_str.to_sym)
          klass.states.index(self.aasm_read_state.to_sym) <=> klass.states.index(state_str.to_sym)
        else
          raise ArgumentError.new("#{state_str}是无效状态名，无法比较")
        end
      else
        super
      end
    end

    # 手动强制修改状态
    def manual_update_state!(to_state, operator)
      ApplicationRecord.transaction do
        state_column = self.class.aasm.attribute_name
        from_state = self.aasm_read_state
        self.update!(state_column => to_state)
        self.state_chains.create!(user_id: operator.id, from: from_state, to: to_state,
                                  event: 'manual_update_state!', assign_time: Time.zone.now)
      end
    end


    private

    def set_related_data(user, args = {})
      raise ArgumentError.new('operator must be a User') unless user.is_a?(User)
      self.operator = user
      self.aasm_args = args
    end

    def log_state_change
      begin
        # 记录状态变更链
        # StateChain.create!(sub_order: self, user: self.operator, from: aasm.from_state, to: aasm.to_state, event: event, assign_time: aasm_args[:time])
        event = aasm.current_event
        assign_time = aasm_args[:assign_time]
        assign_time = nil if assign_time.blank?
        self.state_chains.create!(user_id: self.operator.id, from: aasm.from_state, to: aasm.to_state,
                                  event: event, assign_time: assign_time)
        puts "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
      rescue => e
        raise '状态变更记录创建失败，回退状态变更'
      end
    end

    def after_state_changed
    end
  end
end