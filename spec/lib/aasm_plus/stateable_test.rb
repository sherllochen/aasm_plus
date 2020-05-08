require 'rails_helper'

module AasmPlus
  RSpec.describe "Stateable" do
    let!(:o1) {create(:order, state: 'first', no: '11')}
    let!(:o2) {create(:order, state: 'second', no: '22')}
    let(:user) {create(:user)}

    it "#of_state" do
      expect(Order.of_state('first').length).to eq 1
    end

    it '#of_states' do
      expect(Order.of_states(['first', 'second']).length).to eq 2
    end

    it '#states' do
      expect(Order.states).to eq [:first, :second]
    end

    describe '#trigger_event!' do
      context ' when event not existed' do
        it 'raise error' do
          expect {o1.trigger_event!('xxx', 'user')}.to raise_error(ArgumentError)
        end
      end
    end

    describe '<=>' do
      it "<" do
        expect(o1 < 'second').to eq true
      end

      it "==" do
        expect(o1 == 'first').to eq true
      end

      it ">" do
        expect(o2 > 'first').to eq true
      end
    end

    describe "pass related data when triggering event" do
      let!(:args) {{a: 1, b: 2}}
      context "pass with not User instance" do
        it "raise ArgumentError with 'operator must be a User'" do
          expect {o1.go!('xxxx', args)}.to raise_error(ArgumentError)
        end
      end
      it 'success' do
        o1.go!(user, args)
        expect(o1.operator).to eq user
        expect(o1.aasm_args).to eq args
      end
    end

    it "log state change" do
      expect {o1.go!(user)}.to change {o1.state_chains.count}.from(0).to(1)
    end

    describe '.manual_update_state' do
      it 'update state' do
        expect {o1.manual_update_state!('second', user)}.to change {o1.state}.from('first').to('second')
      end
      it 'log state change' do
        expect {o1.manual_update_state!('second', user)}.to change {o1.state_chains.count}.from(0).to(1)
        expect(o1.state_chains.last.user_id).to eq user.id
        expect(o1.state_chains.last.from).to eq 'first'
        expect(o1.state_chains.last.to).to eq 'second'
        expect(o1.state_chains.last.event).to eq 'manual_update_state!'
      end
    end
  end
end
