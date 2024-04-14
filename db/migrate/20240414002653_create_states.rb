class CreateStates < ActiveRecord::Migration[7.1]
  def change
    create_table :states do |t|
      t.string :state_uid

      t.timestamps
    end
  end
end
