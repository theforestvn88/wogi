class CreateAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :assignments do |t|
      t.references :client, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.datetime :expired_at

      t.timestamps
    end

    add_index :assignments, [:client_id, :product_id], unique: true
  end
end
