class CreateAasmPlusStateChains < ActiveRecord::Migration[5.2]
  def change
    create_table :aasm_plus_state_chains do |t|
      t.integer :user_id
      t.string :from
      t.string :to
      t.string :event
      t.datetime :assign_time
      t.string :stateable_type
      t.integer :stateable_id

      t.timestamps
    end
    add_index :aasm_plus_state_chains, :user_id
    add_index :aasm_plus_state_chains, :from
    add_index :aasm_plus_state_chains, :to
    add_index :aasm_plus_state_chains, :event
    add_index :aasm_plus_state_chains, :assign_time
    add_index :aasm_plus_state_chains, :stateable_type
    add_index :aasm_plus_state_chains, :stateable_id
  end
end
